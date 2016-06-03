module C = Spyboat_core
module O = Spyboat_objects
module L = Spyboat_logic

module P = Client_console.Client

open Core.Std

let rec game_step board = 
  let O.Board(_,_,_,start :: _, _) = board in
  let action = P.get_move board start in
  match L.apply_action board start action true with
  | L.Good(new_bstate) -> game_step new_bstate
  | L.Bad(BadPosition((p_x, p_y), msg)) ->
      Printf.printf "(%d, %d): %s" p_x p_y msg

let main () = 
  let (affects, units, map) = C.get_map () in
  let choice =
    [(6, 1), "Hack 3.0"]
  in
  let b = C.initialize_board affects units map choice in
  game_step b

let bs = main ()
