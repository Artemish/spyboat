module O = Spyboat_objects
module G = Game_logic

module Client : sig
  val get_move : O.BoardState.t -> O.UnitState.t -> G.game_action
end
