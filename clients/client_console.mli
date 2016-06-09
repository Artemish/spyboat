module O = Spyboat_objects
module L = Board_logic

module Client : sig
  val get_move : O.boardstate -> O.unitstate -> L.game_action
end
