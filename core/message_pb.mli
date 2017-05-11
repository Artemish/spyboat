(** message.proto Generated Types and Encoding *)


(** {2 Types} *)

type affect_affect_type =
  | Damage of int
  | Healing of int
  | Floor of bool
  | Stepcap of int
  | Sizecap of int

and affect = {
  affect_type : affect_affect_type;
  name : string option;
  description : string option;
  size_cost : int option;
  reqsize : int option;
  range : int option;
}

type player_id =
  | Player 
  | Enemy 

type program_id = {
  player_id : player_id option;
  unit_id : int option;
}

type position = {
  x : int option;
  y : int option;
}

type program = {
  name : string option;
  description : string option;
  affects : affect list;
  move_rate : int option;
  max_size : int option;
  program_id : program_id option;
  sectors : position list;
}

type cell = {
  passable : bool option;
  unit_id : program_id option;
  credit_value : int option;
}

type grid = {
  width : int option;
  height : int option;
  cells : cell list;
}

type game_state = {
  current_player : player_id option;
  current_unit : program_id option;
  grid : grid option;
  game_over : bool option;
}

type starting_state = {
  grid : grid option;
  templates : program list;
  starts : position list;
  affects : affect list;
  enemies : program list;
}

type player_configuration_program_selection = {
  pos : position option;
  selection_number : int option;
}

type player_configuration = {
  selections : player_configuration_program_selection list;
}

type error = {
  description : string option;
}

type action_do_move = {
  unit : program option;
  target : position option;
}

type action_do_affect = {
  unit : program option;
  affect_name : string option;
  target : position option;
}

type action_do_retire = {
  retiree : program_id option;
}

type action =
  | Move of action_do_move
  | Affect of action_do_affect
  | Undo
  | Retire of action_do_retire

type enemy_action = {
  action : action option;
  game_state : game_state option;
}


(** {2 Default values} *)

val default_affect_affect_type : unit -> affect_affect_type
(** [default_affect_affect_type ()] is the default value for type [affect_affect_type] *)

val default_affect : 
  ?affect_type:affect_affect_type ->
  ?name:string option ->
  ?description:string option ->
  ?size_cost:int option ->
  ?reqsize:int option ->
  ?range:int option ->
  unit ->
  affect
(** [default_affect ()] is the default value for type [affect] *)

val default_player_id : unit -> player_id
(** [default_player_id ()] is the default value for type [player_id] *)

val default_program_id : 
  ?player_id:player_id option ->
  ?unit_id:int option ->
  unit ->
  program_id
(** [default_program_id ()] is the default value for type [program_id] *)

val default_position : 
  ?x:int option ->
  ?y:int option ->
  unit ->
  position
(** [default_position ()] is the default value for type [position] *)

val default_program : 
  ?name:string option ->
  ?description:string option ->
  ?affects:affect list ->
  ?move_rate:int option ->
  ?max_size:int option ->
  ?program_id:program_id option ->
  ?sectors:position list ->
  unit ->
  program
(** [default_program ()] is the default value for type [program] *)

val default_cell : 
  ?passable:bool option ->
  ?unit_id:program_id option ->
  ?credit_value:int option ->
  unit ->
  cell
(** [default_cell ()] is the default value for type [cell] *)

val default_grid : 
  ?width:int option ->
  ?height:int option ->
  ?cells:cell list ->
  unit ->
  grid
(** [default_grid ()] is the default value for type [grid] *)

val default_game_state : 
  ?current_player:player_id option ->
  ?current_unit:program_id option ->
  ?grid:grid option ->
  ?game_over:bool option ->
  unit ->
  game_state
(** [default_game_state ()] is the default value for type [game_state] *)

val default_starting_state : 
  ?grid:grid option ->
  ?templates:program list ->
  ?starts:position list ->
  ?affects:affect list ->
  ?enemies:program list ->
  unit ->
  starting_state
(** [default_starting_state ()] is the default value for type [starting_state] *)

val default_player_configuration_program_selection : 
  ?pos:position option ->
  ?selection_number:int option ->
  unit ->
  player_configuration_program_selection
(** [default_player_configuration_program_selection ()] is the default value for type [player_configuration_program_selection] *)

val default_player_configuration : 
  ?selections:player_configuration_program_selection list ->
  unit ->
  player_configuration
(** [default_player_configuration ()] is the default value for type [player_configuration] *)

val default_error : 
  ?description:string option ->
  unit ->
  error
(** [default_error ()] is the default value for type [error] *)

val default_action_do_move : 
  ?unit:program option ->
  ?target:position option ->
  unit ->
  action_do_move
(** [default_action_do_move ()] is the default value for type [action_do_move] *)

val default_action_do_affect : 
  ?unit:program option ->
  ?affect_name:string option ->
  ?target:position option ->
  unit ->
  action_do_affect
(** [default_action_do_affect ()] is the default value for type [action_do_affect] *)

val default_action_do_retire : 
  ?retiree:program_id option ->
  unit ->
  action_do_retire
(** [default_action_do_retire ()] is the default value for type [action_do_retire] *)

val default_action : unit -> action
(** [default_action ()] is the default value for type [action] *)

val default_enemy_action : 
  ?action:action option ->
  ?game_state:game_state option ->
  unit ->
  enemy_action
(** [default_enemy_action ()] is the default value for type [enemy_action] *)


(** {2 Protobuf Decoding} *)

val decode_affect_affect_type : Pbrt.Decoder.t -> affect_affect_type
(** [decode_affect_affect_type decoder] decodes a [affect_affect_type] value from [decoder] *)

val decode_affect : Pbrt.Decoder.t -> affect
(** [decode_affect decoder] decodes a [affect] value from [decoder] *)

val decode_player_id : Pbrt.Decoder.t -> player_id
(** [decode_player_id decoder] decodes a [player_id] value from [decoder] *)

val decode_program_id : Pbrt.Decoder.t -> program_id
(** [decode_program_id decoder] decodes a [program_id] value from [decoder] *)

val decode_position : Pbrt.Decoder.t -> position
(** [decode_position decoder] decodes a [position] value from [decoder] *)

val decode_program : Pbrt.Decoder.t -> program
(** [decode_program decoder] decodes a [program] value from [decoder] *)

val decode_cell : Pbrt.Decoder.t -> cell
(** [decode_cell decoder] decodes a [cell] value from [decoder] *)

val decode_grid : Pbrt.Decoder.t -> grid
(** [decode_grid decoder] decodes a [grid] value from [decoder] *)

val decode_game_state : Pbrt.Decoder.t -> game_state
(** [decode_game_state decoder] decodes a [game_state] value from [decoder] *)

val decode_starting_state : Pbrt.Decoder.t -> starting_state
(** [decode_starting_state decoder] decodes a [starting_state] value from [decoder] *)

val decode_player_configuration_program_selection : Pbrt.Decoder.t -> player_configuration_program_selection
(** [decode_player_configuration_program_selection decoder] decodes a [player_configuration_program_selection] value from [decoder] *)

val decode_player_configuration : Pbrt.Decoder.t -> player_configuration
(** [decode_player_configuration decoder] decodes a [player_configuration] value from [decoder] *)

val decode_error : Pbrt.Decoder.t -> error
(** [decode_error decoder] decodes a [error] value from [decoder] *)

val decode_action_do_move : Pbrt.Decoder.t -> action_do_move
(** [decode_action_do_move decoder] decodes a [action_do_move] value from [decoder] *)

val decode_action_do_affect : Pbrt.Decoder.t -> action_do_affect
(** [decode_action_do_affect decoder] decodes a [action_do_affect] value from [decoder] *)

val decode_action_do_retire : Pbrt.Decoder.t -> action_do_retire
(** [decode_action_do_retire decoder] decodes a [action_do_retire] value from [decoder] *)

val decode_action : Pbrt.Decoder.t -> action
(** [decode_action decoder] decodes a [action] value from [decoder] *)

val decode_enemy_action : Pbrt.Decoder.t -> enemy_action
(** [decode_enemy_action decoder] decodes a [enemy_action] value from [decoder] *)


(** {2 Protobuf Toding} *)

val encode_affect_affect_type : affect_affect_type -> Pbrt.Encoder.t -> unit
(** [encode_affect_affect_type v encoder] encodes [v] with the given [encoder] *)

val encode_affect : affect -> Pbrt.Encoder.t -> unit
(** [encode_affect v encoder] encodes [v] with the given [encoder] *)

val encode_player_id : player_id -> Pbrt.Encoder.t -> unit
(** [encode_player_id v encoder] encodes [v] with the given [encoder] *)

val encode_program_id : program_id -> Pbrt.Encoder.t -> unit
(** [encode_program_id v encoder] encodes [v] with the given [encoder] *)

val encode_position : position -> Pbrt.Encoder.t -> unit
(** [encode_position v encoder] encodes [v] with the given [encoder] *)

val encode_program : program -> Pbrt.Encoder.t -> unit
(** [encode_program v encoder] encodes [v] with the given [encoder] *)

val encode_cell : cell -> Pbrt.Encoder.t -> unit
(** [encode_cell v encoder] encodes [v] with the given [encoder] *)

val encode_grid : grid -> Pbrt.Encoder.t -> unit
(** [encode_grid v encoder] encodes [v] with the given [encoder] *)

val encode_game_state : game_state -> Pbrt.Encoder.t -> unit
(** [encode_game_state v encoder] encodes [v] with the given [encoder] *)

val encode_starting_state : starting_state -> Pbrt.Encoder.t -> unit
(** [encode_starting_state v encoder] encodes [v] with the given [encoder] *)

val encode_player_configuration_program_selection : player_configuration_program_selection -> Pbrt.Encoder.t -> unit
(** [encode_player_configuration_program_selection v encoder] encodes [v] with the given [encoder] *)

val encode_player_configuration : player_configuration -> Pbrt.Encoder.t -> unit
(** [encode_player_configuration v encoder] encodes [v] with the given [encoder] *)

val encode_error : error -> Pbrt.Encoder.t -> unit
(** [encode_error v encoder] encodes [v] with the given [encoder] *)

val encode_action_do_move : action_do_move -> Pbrt.Encoder.t -> unit
(** [encode_action_do_move v encoder] encodes [v] with the given [encoder] *)

val encode_action_do_affect : action_do_affect -> Pbrt.Encoder.t -> unit
(** [encode_action_do_affect v encoder] encodes [v] with the given [encoder] *)

val encode_action_do_retire : action_do_retire -> Pbrt.Encoder.t -> unit
(** [encode_action_do_retire v encoder] encodes [v] with the given [encoder] *)

val encode_action : action -> Pbrt.Encoder.t -> unit
(** [encode_action v encoder] encodes [v] with the given [encoder] *)

val encode_enemy_action : enemy_action -> Pbrt.Encoder.t -> unit
(** [encode_enemy_action v encoder] encodes [v] with the given [encoder] *)


(** {2 Formatters} *)

val pp_affect_affect_type : Format.formatter -> affect_affect_type -> unit 
(** [pp_affect_affect_type v] formats v *)

val pp_affect : Format.formatter -> affect -> unit 
(** [pp_affect v] formats v *)

val pp_player_id : Format.formatter -> player_id -> unit 
(** [pp_player_id v] formats v *)

val pp_program_id : Format.formatter -> program_id -> unit 
(** [pp_program_id v] formats v *)

val pp_position : Format.formatter -> position -> unit 
(** [pp_position v] formats v *)

val pp_program : Format.formatter -> program -> unit 
(** [pp_program v] formats v *)

val pp_cell : Format.formatter -> cell -> unit 
(** [pp_cell v] formats v *)

val pp_grid : Format.formatter -> grid -> unit 
(** [pp_grid v] formats v *)

val pp_game_state : Format.formatter -> game_state -> unit 
(** [pp_game_state v] formats v *)

val pp_starting_state : Format.formatter -> starting_state -> unit 
(** [pp_starting_state v] formats v *)

val pp_player_configuration_program_selection : Format.formatter -> player_configuration_program_selection -> unit 
(** [pp_player_configuration_program_selection v] formats v *)

val pp_player_configuration : Format.formatter -> player_configuration -> unit 
(** [pp_player_configuration v] formats v *)

val pp_error : Format.formatter -> error -> unit 
(** [pp_error v] formats v *)

val pp_action_do_move : Format.formatter -> action_do_move -> unit 
(** [pp_action_do_move v] formats v *)

val pp_action_do_affect : Format.formatter -> action_do_affect -> unit 
(** [pp_action_do_affect v] formats v *)

val pp_action_do_retire : Format.formatter -> action_do_retire -> unit 
(** [pp_action_do_retire v] formats v *)

val pp_action : Format.formatter -> action -> unit 
(** [pp_action v] formats v *)

val pp_enemy_action : Format.formatter -> enemy_action -> unit 
(** [pp_enemy_action v] formats v *)
