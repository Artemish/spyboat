module O = Spyboat_objects

open Core.Std

type direction = LEFT | RIGHT | UP | DOWN

type undo_information = 
  | HeadCut of O.credit option
  | TailAdd of O.position * O.credit option
  | RefitHead of O.position list

type board_action =
  | Attack of (O.affect * O.position)
  | Step of direction
  | Undo of undo_information

type game_action = 
  | BoardAction of board_action
  | RetireUnit
  | EndTurn

type action_error =
  (* Couldn't find the corresponding UID *)
  | NoSuchUnit of O.uuid
  (* No commandeering other boats *)
  | NotYourUnit of O.uuid
  (* Given unit doesn't have that action *)
  | NoSuchAffect of string
  (* Off the map, out of range, etc *)
  | BadPosition of (O.position * string)
  (* I'm the captain here! *)
  | NotYourTurn

type response =
  | Good of O.boardstate * undo_information option
  | Bad of action_error


(* TODO generalize to N players... big todo lol *)
(* {{{ Update unit in board *)
let update_unit_in_board boat board is_player = 
  let O.Board(width, height, cells, player_units, enemy_units) = board in
  let O.Boat(_, uid, _, _, _, _) = boat in
  let baselist = if is_player then player_units else enemy_units in
  let switcher =
    (fun b ->
      let O.Boat(_, uid', _, _, _, _) = b in
      if (uid' = uid) then boat else b)
  in
  let newlist = List.map ~f:switcher baselist in
  if is_player
  then O.Board(width, height, cells, newlist, enemy_units)
  else O.Board(width, height, cells, player_units, newlist)
(* }}} *)

let within_bounds (p_x, p_y) board = 
  let O.Board(width, height, _, _, _) = board in
  (p_x >= 0) && (p_x < width) && (p_y >= 0) && (p_y < height)

let rec cut_last lst =
  match lst with
    (* Should never happen in our use case *)
    [] -> raise (Invalid_argument("Uh oh"))
  | [h] -> ([], h)
  | h :: t -> let (cut, last) = cut_last t in (h::cut, last)

(* TODO do away with player vs. enemy and add player IDs *)
(* {{{ Handle step *)
let handle_step boat board dir is_player = 
  let O.Board(width, height, cells, player_units, enemy_units) = board in
  let O.Boat(base, actor_uid, head, sectors, maxsize, moverate) = boat in
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
    let O.Cell(passable, uid_opt, credit_opt) = cells.(newpos_y).(newpos_x) in
    if (not passable) 
    then Bad(BadPosition(newpos, "Terrain impassable"))
    else
      (* Grab the cell we're moving in to *)
      let O.Cell(passable, uid_opt, credit_opt) = cells.(newpos_y).(newpos_x) in
      match uid_opt with
      | None -> 
          (* Moving onto a blank square *)
          let new_unitstate, undo_information = 
            if (List.length sectors) >= maxsize
            then 
              (* Cut out the last sector of the moving unit *)
              let (remaining, (old_x, old_y)) = cut_last sectors in
              let O.Cell(old_passable, _, _) = cells.(old_y).(old_x) in

              (* Keep the passability, but squares with units on them should
               * have no credits, and squares can be made impassable while a
               * unit is still on it *)
              let () = cells.(old_y).(old_x) <- O.Cell(old_passable, None, None) in

              let boat = O.Boat(base, actor_uid, newpos, newpos :: remaining, maxsize, moverate) in
              let undo = Some(TailAdd((old_x, old_y), credit_opt)) in
              boat, undo

            else 
              let boat = O.Boat(base, actor_uid, newpos, newpos :: sectors, maxsize, moverate) in
              let undo = Some(HeadCut(credit_opt)) in
              boat, undo
          in

          let () = cells.(newpos_y).(newpos_x) <- O.Cell(passable, Some(actor_uid), None) in

          let new_board = update_unit_in_board new_unitstate board is_player in
          Good(new_board, undo_information)

      | Some(target_uid) ->
          (* Stepping over yourself *)
          if (target_uid <> actor_uid)
          then Bad(BadPosition(newpos, "Can't move into another unit"))
          else 
            (* replace sector *)
            let filter_newpos = List.filter ~f:((<>) newpos) sectors in
            let new_sectors = newpos :: filter_newpos in
            let new_unitstate = 
              O.Boat(base, actor_uid, newpos, new_sectors, maxsize, moverate)
            in

            let new_board = update_unit_in_board new_unitstate board is_player in
            let undo_information = Some(RefitHead(sectors)) in
            Good(new_board, undo_information)
(* }}} *)

(* {{{ Handle undo *)
let handle_undo undo_info board boat is_player =
  let O.Board(width, height, cells, player_units, enemy_units) = board in
  let O.Boat(base, uid, (h_x, h_y), sectors, maxsize, moverate) = boat in
  let new_unit =
    match undo_info with
    | TailAdd((r_x, r_y), credit_opt) ->
        (* Restore the cell at r_x, r_y *)
        let O.Cell(r_passable, _, _) = cells.(r_y).(r_x) in
        let O.Cell(h_passable, _, _) = cells.(h_y).(h_x) in
        let _ :: remaining = sectors in
        let new_sectors = List.append remaining [(r_x, r_y)] in
        let new_head = List.hd_exn new_sectors in

        let () = cells.(r_y).(r_x) <- O.Cell(r_passable, Some(uid), None) in
        let () = cells.(h_y).(h_x) <- O.Cell(h_passable, None, None) in

        O.Boat(base, uid, new_head, new_sectors, maxsize, moverate)

    | HeadCut(credit_opt) ->
        let _ :: remaining = sectors in
        let new_head = List.hd_exn remaining in
        let O.Cell(h_passable, _, _) = cells.(h_y).(h_x) in
        let () = cells.(h_y).(h_x) <- O.Cell(h_passable, None, credit_opt) in
        O.Boat(base, uid, new_head, remaining, maxsize, moverate)
    | RefitHead(previous_sectors) ->
        (* No cells need updating, sectors were merely shuffled *)
        let new_head = List.hd_exn previous_sectors in
        O.Boat(base, uid, new_head, previous_sectors, maxsize, moverate)
  in

  let new_board = update_unit_in_board new_unit board is_player in
  Good(new_board, None)
(* }}} *)

let apply_action board boat action is_player =
  match action with
  | Step(dir) ->
      handle_step boat board dir is_player
  | Undo(undo_info) -> handle_undo undo_info board boat is_player
  | _ -> Bad(NotYourTurn)
