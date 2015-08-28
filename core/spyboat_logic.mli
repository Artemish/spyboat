module O = Spyboat_objects

(*  Update board according to player action; side-effecty *)
type action =
  | Attack of (O.unitstate * O.affect * O.position)
  | Step of (O.unitstate * O.position)
  | Retire of O.unitstate
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
  | Good
  | Bad of action_error

val apply_action : O.boardstate -> action -> response
