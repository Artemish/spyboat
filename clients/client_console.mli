module O = Spyboat_objects
module L = Spyboat_logic

module Client : sig
  val get_move : O.boardstate -> O.unitstate -> L.action
end
