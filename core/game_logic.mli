module O = Spyboat_objects
module B = Board_logic

open Core.Std

type game_action = 
  | BoardAction of B.board_action
  | RetireUnit
  | EndTurn

type game_error =
  | NotYourTurn
  | NoSuchAffect
