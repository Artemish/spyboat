module O = Spyboat_objects

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

val apply_action : O.boardstate -> O.unitstate -> action -> bool -> response
