module O = Spyboat_objects

open Core.Std

type direction = LEFT | RIGHT | UP | DOWN
(*  Update board according to player action; side-effecty *)
type action =
  | Attack of (O.affect * O.position)
  | Step of direction

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
  | Good of O.boardstate
  | Bad of action_error

(* TODO generalize to N players... big todo lol *)
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
      let O.Cell(passable, uid_opt, credit_opt) = cells.(newpos_y).(newpos_x) in
      match uid_opt with
      | None -> 
          (* Moving onto a blank square *)
          let new_unitstate = 
            if (List.length sectors) >= maxsize
            then 
              let (remaining, (old_x, old_y)) = cut_last sectors in
              let O.Cell(old_passable, _, old_credit) = cells.(old_y).(old_x) in

              let () = cells.(old_y).(old_x) <- O.Cell(old_passable, None, old_credit) in

              O.Boat(base, actor_uid, newpos, newpos :: remaining, maxsize, moverate)

            else O.Boat(base, actor_uid, newpos, newpos :: sectors, maxsize, moverate)
          in

          let O.Cell(passable, _, credit) = cells.(newpos_y).(newpos_x) in
          let () = cells.(newpos_y).(newpos_x) <- O.Cell(passable, Some(actor_uid), credit) in

          let new_board = update_unit_in_board new_unitstate board is_player in
          Good(new_board)

      | Some(target_uid) ->
          (* Stepping over yourself *)
          if (target_uid <> actor_uid)
          then Bad(BadPosition(newpos, "Can't move into another unit"))
          else 
            (* replace sector *)
            let filter_head = List.filter ~f:((<>) head) sectors in
            let new_sectors = newpos :: filter_head in
            let new_unitstate = 
              O.Boat(base, actor_uid, newpos, new_sectors, maxsize, moverate)
            in

            let new_board = update_unit_in_board new_unitstate board is_player in
            Good(new_board)

let apply_action board boat action is_player =
  match action with
  | Step(dir) ->
      handle_step boat board dir is_player
  | _ -> Bad(NotYourTurn)
