module C = Spyboat_core
module O = Spyboat_objects
module B = Board_logic
module G = Game_logic

module P = Client_console.Client

open Core.Std

let rec game_step board undostack = 
  let module BS = O.BoardState in

  let {BS.player_units = start :: _} = board in
  let action = P.get_move board start in
  
  let translated_action, undostack = 
    match action with
    | G.BoardAction(Board_logic.Undo(B.HeadCut(None))) ->
        let undo_step :: remaining = undostack in
        G.BoardAction(B.Undo(undo_step)), remaining
    | _ -> action, undostack
  in

  match translated_action with
  | G.BoardAction(baction) ->
    (match B.apply_action board start baction with
    | B.Good(new_bstate, undo_opt) ->
        let new_undostack =
          (match undo_opt with
          | Some(undo) -> undo :: undostack
          | None -> undostack)
        in 
        
        game_step new_bstate new_undostack
    | B.Bad(B.BadPosition((p_x, p_y), msg)) ->
        Printf.printf "(%d, %d): %s" p_x p_y msg
    | B.Bad(B.BadTarget(reason)) ->
        Printf.printf "Bad: %s" reason)
 | RetireUnit -> ()
 | EndTurn -> ()


let main () = 
  let (affects, units, map) = C.get_map () in
  let choice =
    [(6, 1), "Hack 3.0"; (7,1), "Hack 3.0"]
  in
  let b = C.initialize_board affects units map choice in
  game_step b []

let bs = main ()
