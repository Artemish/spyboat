module O = Spyboat_objects

type direction = LEFT | RIGHT | UP | DOWN

(* Since we're working with side effects, we can't rely on keeping state
 * history information, and if a move can be undone, this type will encapsulate
 * the steps the board logic will take to return the board to its previous
 * state. *)
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

val apply_action : O.boardstate -> O.unitstate -> board_action -> response
