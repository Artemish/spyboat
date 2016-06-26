module O = Spyboat_objects
module L = Board_logic

module Client : sig
  val get_move : O.BoardState.t -> O.UnitState.t -> L.game_action
end
