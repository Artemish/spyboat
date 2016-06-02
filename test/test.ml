module C = Spyboat_core
module O = Spyboat_objects
module L = Spyboat_logic

module P = Client_console.Client

open Core.Std

let main () = 
  let (affects, units, map) = C.get_map () in
  let choice =
    [(6, 1), "Hack 3.0"]
  in
  let b = C.initialize_board affects units map choice in
  let O.Board(_,_,_,start :: _, _) = b in
  let action = P.get_move b start in
  match L.apply_action b start action true with
  | L.Good(new_bstate) -> P.get_move new_bstate start
  | L.Bad(BadPosition((p_x, p_y), msg)) ->
      Printf.printf "(%d, %d): %s" p_x p_y msg;
      L.Step(UP)

let bs = main ()
