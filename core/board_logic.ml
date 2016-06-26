module O = Spyboat_objects

open Core.Std

type direction = LEFT | RIGHT | UP | DOWN

type undo_information = 
  | HeadCut of O.credit option
  | TailAdd of O.position * O.credit option
  | RefitHead of O.position list

type board_action =
  | Attack of (O.Affect.t * O.position)
  | Step of direction
  | Undo of undo_information

type game_action = 
  | BoardAction of board_action
  | RetireUnit
  | EndTurn

type action_error =
  (* Couldn't find the corresponding UID *)
  | NoSuchUnit of O.unit_id
  (* No commandeering other boats *)
  | NotYourUnit of O.unit_id
  (* Given unit doesn't have that action *)
  | NoSuchAffect of string
  (* Off the map, out of range, etc *)
  | BadPosition of (O.position * string)
  (* I'm the captain here! *)
  | NotYourTurn

type response =
  | Good of O.BoardState.t * undo_information option
  | Bad of action_error


(* TODO generalize to N players... big todo lol *)
(* {{{ Update unit in board *)
let update_unit_in_board boat board = 
  let player_id = O.UnitState.pid boat in
  let uid = O.UnitState.uid boat in

  let baselist =
    if player_id = O.Player
    then O.BoardState.player_units board
    else O.BoardState.enemy_units board
  in

  let same = (fun b -> O.UnitState.uid b != uid) in

  if player_id = O.Player
  then 
    let newlist = boat :: (List.filter ~f:same (O.BoardState.player_units board)) in
    {board with player_units = newlist;}
  else 
    let newlist = boat :: (List.filter ~f:same (O.BoardState.enemy_units board)) in
    {board with enemy_units = newlist;}
(* }}} *)

let within_bounds (p_x, p_y) board = 
  let (width, height) = (O.BoardState.width board, O.BoardState.height board) in
  (p_x >= 0) && (p_x < width) && (p_y >= 0) && (p_y < height)

let rec cut_last lst =
  match lst with
    (* Should never happen in our use case *)
    [] -> raise (Invalid_argument("Uh oh"))
  | [h] -> ([], h)
  | h :: t -> let (cut, last) = cut_last t in (h::cut, last)

(* TODO do away with player vs. enemy and add player IDs *)
(* {{{ Handle step *)
let handle_step boat board dir = 
  let module B = O.BoardState in
  let module U = O.UnitState in
  let module C = O.Cell in

  let {B.width; B.height; B.cells} = board in
  let {U.uid = actor_uid; U.head; U.sectors; U.max_size} = boat in

  let (pos_x, pos_y) = head in
  let (newpos_x, newpos_y) as newpos = 
    (match dir with
    | UP -> (pos_x, pos_y - 1)
    | DOWN -> (pos_x, pos_y + 1)
    | LEFT -> (pos_x - 1, pos_y)
    | RIGHT -> (pos_x + 1, pos_y))
  in 

  if (not (within_bounds newpos board))
  then Bad(BadPosition(newpos, "Off the map"))
  else 
    let {C.passable; C.uid_opt; C.credit_opt} = cells.(newpos_y).(newpos_x) in
    if (not passable) 
    then Bad(BadPosition(newpos, "Terrain impassable"))
    else
      (* Grab the cell we're moving in to *)
      match uid_opt with
      | None -> 
          (* Moving onto a blank square *)
          let new_unitstate, undo_information = 
            if (List.length sectors) >= max_size
            then 
              (* Cut out the last sector of the moving unit *)
              let (remaining, (old_x, old_y)) = cut_last sectors in
              let old_cell = cells.(old_y).(old_x) in

              let () = cells.(old_y).(old_x) <- {old_cell with uid_opt = None} in

              let boat = {boat with head = newpos; sectors = newpos :: remaining} in
              let undo = Some(TailAdd((old_x, old_y), old_cell.credit_opt)) in
              boat, undo

            else 
              let boat = {boat with head = newpos; sectors = newpos :: sectors} in
              let undo = Some(HeadCut(credit_opt)) in
              boat, undo
          in

          let () = cells.(newpos_y).(newpos_x) <- {passable; uid_opt = Some(actor_uid); credit_opt} in

          let new_board = update_unit_in_board new_unitstate board in
          Good(new_board, undo_information)

      | Some(target_uid) ->
          (* Stepping over yourself *)
          if (target_uid <> actor_uid)
          then Bad(BadPosition(newpos, "Can't move into another unit"))
          else 
            (* replace sector *)
            let filter_newpos = List.filter ~f:((<>) newpos) sectors in
            let new_sectors = newpos :: filter_newpos in
            let new_unitstate = {boat with head = newpos; sectors = new_sectors} in

            let new_board = update_unit_in_board new_unitstate board in
            let undo_information = Some(RefitHead(sectors)) in
            Good(new_board, undo_information)
(* }}} *)

(* {{{ Handle undo *)
let handle_undo undo_info board boat =
  let module B = O.BoardState in 
  let module U = O.UnitState in 
  let module C = O.Cell in 

  let {B.cells} = board in
  let {U.uid; U.head = (h_x, h_y); U.sectors} = boat in
  let new_unit =
    match undo_info with
    | TailAdd((r_x, r_y), credit_opt) ->
        (* Restore the cell at r_x, r_y *)
        let {C.passable = r_passable} = cells.(r_y).(r_x) in
        let {C.passable = r_passable} = cells.(h_y).(h_x) in
        (* TODO check w/ exception *)
        let _ :: remaining = sectors in
        let new_sectors = List.append remaining [(r_x, r_y)] in
        let new_head = List.hd_exn new_sectors in

        let () = cells.(r_y).(r_x) <- {cells.(r_y).(r_x) with C.uid_opt = Some(uid)} in
        let () = cells.(h_y).(h_x) <- {cells.(r_y).(r_x) with C.uid_opt = None} in

        {boat with head = new_head; sectors = new_sectors}

    | HeadCut(credit_opt) ->
        let _ :: remaining = sectors in
        let new_head = List.hd_exn remaining in
        let new_cell = {cells.(h_y).(h_x) with uid_opt = None; credit_opt = credit_opt} in
        let () = cells.(h_y).(h_x) <- new_cell in
        {boat with U.head = new_head; U.sectors = remaining}
    | RefitHead(previous_sectors) ->
        (* No cells need updating, sectors were merely shuffled *)
        let new_head = List.hd_exn previous_sectors in
        {boat with U.head = new_head; U.sectors = previous_sectors}
  in

  let new_board = update_unit_in_board new_unit board in
  Good(new_board, None)
(* }}} *)

let unit_lookup uid_opt board = 
  let module B = O.BoardState in 
  let module U = O.UnitState in 

  let {B.player_units; B.enemy_units} = board in
  match uid_opt with
  | None -> None
  | Some(uid) -> 
      let same_name {U.uid = uid'} = uid' = uid in
      (match List.find ~f:same_name player_units with
      | Some(boat) -> Some(boat)
      | None ->
          (match List.find ~f:same_name player_units with
          | Some(boat) -> Some(boat)
          | None -> None))

let handle_attack board boat affect (t_x, t_y) = 
  let module B = O.BoardState in 
  let module U = O.UnitState in 
  let module C = O.Cell in 
  let module A = O.Affect in 

  let {B.cells} = board in
  (* TODO Handle nonexistent affect? *)
  let {U.pid; U.uid; U.head = (h_x, h_y)} = boat in
  let {A.atype; A.cost; A.reqsize; A.range} = affect in

  if not (within_bounds (t_x, t_y) board) 
  then Bad(BadPosition((t_x, t_y), "Off the map"))
  else
    let {C.uid_opt; C.credit_opt} as old_cell = cells.(t_y).(t_x) in
    let boat_opt = unit_lookup uid_opt board in
    match (atype, boat_opt) with
    | (A.FLOOR(new_passability), _) ->
        let () = cells.(t_y).(t_x) <-  {old_cell with C.passable = new_passability} in
        Good(board, None)
    

let apply_action board boat action =
  match action with
  | Step(dir) ->
      handle_step boat board dir 
  | Undo(undo_info) -> handle_undo undo_info board boat 
  | Attack(affect, target) -> handle_attack board boat affect target 
  | _ -> Bad(NotYourTurn)
