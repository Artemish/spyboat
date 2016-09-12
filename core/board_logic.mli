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
  | Attack of (O.Affect.t * O.position)
  | Step of direction
  | Undo of undo_information

type action_error =
  (* Couldn't find the corresponding UID *)
  | NoSuchUnit of O.unit_id
  (* No commandeering other boats *)
  | NotYourUnit of O.unit_id
  (* Given unit doesn't have that action *)
  | NoSuchAffect of string
  (* Off the map, out of range, etc *)
  | BadPosition of (O.position * string)
  (* Heal enemy, attack ally, etc *)
  | BadTarget of string

type response =
  | Good of O.BoardState.t * undo_information option
  | Bad of action_error

val apply_action : O.BoardState.t -> O.UnitState.t -> board_action -> response
