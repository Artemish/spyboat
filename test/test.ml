module C = Spyboat_core
module O = Spyboat_objects
module L = Board_logic

module P = Client_console.Client

open Core.Std

let rec game_step board undostack = 
  let O.Board(_,_,_,start :: _, _) = board in
  let action = P.get_move board start in
  
  let translated_action, undostack = 
    match action with
    | L.BoardAction(L.Undo(L.HeadCut(None))) ->
        let undo_step :: remaining = undostack in
        L.BoardAction(L.Undo(undo_step)), remaining
    | _ -> action, undostack
  in

  match translated_action with
  | L.BoardAction(baction) ->
    (match L.apply_action board start baction with
    | L.Good(new_bstate, undo_opt) ->
        let new_undostack =
          (match undo_opt with
          | Some(undo) -> undo :: undostack
          | None -> undostack)
        in 
        
        game_step new_bstate new_undostack
    | L.Bad(L.BadPosition((p_x, p_y), msg)) ->
        Printf.printf "(%d, %d): %s" p_x p_y msg)
 | RetireUnit -> ()
 | EndTurn -> ()


let main () = 
  let (affects, units, map) = C.get_map () in
  let choice =
    [(6, 1), "Hack 3.0"]
  in
  let b = C.initialize_board affects units map choice in
  game_step b []

let bs = main ()
