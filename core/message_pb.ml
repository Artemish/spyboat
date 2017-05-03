[@@@ocaml.warning "-27-30-39"]

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

and affect_mutable = {
  mutable affect_type : affect_affect_type;
  mutable name : string option;
  mutable description : string option;
  mutable size_cost : int option;
  mutable reqsize : int option;
  mutable range : int option;
}

type player_id =
  | Player 
  | Enemy 

type program_id = {
  player_id : player_id option;
  unit_id : int option;
}

and program_id_mutable = {
  mutable player_id : player_id option;
  mutable unit_id : int option;
}

type position = {
  x : int option;
  y : int option;
}

and position_mutable = {
  mutable x : int option;
  mutable y : int option;
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

and program_mutable = {
  mutable name : string option;
  mutable description : string option;
  mutable affects : affect list;
  mutable move_rate : int option;
  mutable max_size : int option;
  mutable program_id : program_id option;
  mutable sectors : position list;
}

type cell = {
  passable : bool option;
  unit_id : program_id option;
  credit_value : int option;
}

and cell_mutable = {
  mutable passable : bool option;
  mutable unit_id : program_id option;
  mutable credit_value : int option;
}

type grid = {
  width : int option;
  height : int option;
  cells : cell list;
}

and grid_mutable = {
  mutable width : int option;
  mutable height : int option;
  mutable cells : cell list;
}

type game_state = {
  current_player : player_id option;
  current_unit : program_id option;
  grid : grid option;
  game_over : bool option;
}

and game_state_mutable = {
  mutable current_player : player_id option;
  mutable current_unit : program_id option;
  mutable grid : grid option;
  mutable game_over : bool option;
}

type starting_state = {
  board : grid option;
  templates : program list;
  starts : position list;
}

and starting_state_mutable = {
  mutable board : grid option;
  mutable templates : program list;
  mutable starts : position list;
}

type player_configuration_program_selection = {
  pos : position option;
  selection_number : int option;
}

and player_configuration_program_selection_mutable = {
  mutable pos : position option;
  mutable selection_number : int option;
}

type player_configuration = {
  selections : player_configuration_program_selection list;
}

and player_configuration_mutable = {
  mutable selections : player_configuration_program_selection list;
}

type error = {
  description : string option;
}

and error_mutable = {
  mutable description : string option;
}

type action_do_move = {
  unit : program option;
  target : position option;
}

and action_do_move_mutable = {
  mutable unit : program option;
  mutable target : position option;
}

type action_do_affect = {
  unit : program option;
  affect_name : string option;
  target : position option;
}

and action_do_affect_mutable = {
  mutable unit : program option;
  mutable affect_name : string option;
  mutable target : position option;
}

type action_do_retire = {
  retiree : program_id option;
}

and action_do_retire_mutable = {
  mutable retiree : program_id option;
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

and enemy_action_mutable = {
  mutable action : action option;
  mutable game_state : game_state option;
}

let rec default_affect_affect_type () : affect_affect_type = Damage (0)

and default_affect 
  ?affect_type:((affect_type:affect_affect_type) = Damage (0))
  ?name:((name:string option) = None)
  ?description:((description:string option) = None)
  ?size_cost:((size_cost:int option) = None)
  ?reqsize:((reqsize:int option) = None)
  ?range:((range:int option) = None)
  () : affect  = {
  affect_type;
  name;
  description;
  size_cost;
  reqsize;
  range;
}

and default_affect_mutable () : affect_mutable = {
  affect_type = Damage (0);
  name = None;
  description = None;
  size_cost = None;
  reqsize = None;
  range = None;
}

let rec default_player_id () = (Player:player_id)

let rec default_program_id 
  ?player_id:((player_id:player_id option) = None)
  ?unit_id:((unit_id:int option) = None)
  () : program_id  = {
  player_id;
  unit_id;
}

and default_program_id_mutable () : program_id_mutable = {
  player_id = None;
  unit_id = None;
}

let rec default_position 
  ?x:((x:int option) = None)
  ?y:((y:int option) = None)
  () : position  = {
  x;
  y;
}

and default_position_mutable () : position_mutable = {
  x = None;
  y = None;
}

let rec default_program 
  ?name:((name:string option) = None)
  ?description:((description:string option) = None)
  ?affects:((affects:affect list) = [])
  ?move_rate:((move_rate:int option) = None)
  ?max_size:((max_size:int option) = None)
  ?program_id:((program_id:program_id option) = None)
  ?sectors:((sectors:position list) = [])
  () : program  = {
  name;
  description;
  affects;
  move_rate;
  max_size;
  program_id;
  sectors;
}

and default_program_mutable () : program_mutable = {
  name = None;
  description = None;
  affects = [];
  move_rate = None;
  max_size = None;
  program_id = None;
  sectors = [];
}

let rec default_cell 
  ?passable:((passable:bool option) = Some (true))
  ?unit_id:((unit_id:program_id option) = None)
  ?credit_value:((credit_value:int option) = None)
  () : cell  = {
  passable;
  unit_id;
  credit_value;
}

and default_cell_mutable () : cell_mutable = {
  passable = Some (true);
  unit_id = None;
  credit_value = None;
}

let rec default_grid 
  ?width:((width:int option) = Some (16))
  ?height:((height:int option) = Some (13))
  ?cells:((cells:cell list) = [])
  () : grid  = {
  width;
  height;
  cells;
}

and default_grid_mutable () : grid_mutable = {
  width = Some (16);
  height = Some (13);
  cells = [];
}

let rec default_game_state 
  ?current_player:((current_player:player_id option) = None)
  ?current_unit:((current_unit:program_id option) = None)
  ?grid:((grid:grid option) = None)
  ?game_over:((game_over:bool option) = None)
  () : game_state  = {
  current_player;
  current_unit;
  grid;
  game_over;
}

and default_game_state_mutable () : game_state_mutable = {
  current_player = None;
  current_unit = None;
  grid = None;
  game_over = None;
}

let rec default_starting_state 
  ?board:((board:grid option) = None)
  ?templates:((templates:program list) = [])
  ?starts:((starts:position list) = [])
  () : starting_state  = {
  board;
  templates;
  starts;
}

and default_starting_state_mutable () : starting_state_mutable = {
  board = None;
  templates = [];
  starts = [];
}

let rec default_player_configuration_program_selection 
  ?pos:((pos:position option) = None)
  ?selection_number:((selection_number:int option) = None)
  () : player_configuration_program_selection  = {
  pos;
  selection_number;
}

and default_player_configuration_program_selection_mutable () : player_configuration_program_selection_mutable = {
  pos = None;
  selection_number = None;
}

let rec default_player_configuration 
  ?selections:((selections:player_configuration_program_selection list) = [])
  () : player_configuration  = {
  selections;
}

and default_player_configuration_mutable () : player_configuration_mutable = {
  selections = [];
}

let rec default_error 
  ?description:((description:string option) = None)
  () : error  = {
  description;
}

and default_error_mutable () : error_mutable = {
  description = None;
}

let rec default_action_do_move 
  ?unit:((unit:program option) = None)
  ?target:((target:position option) = None)
  () : action_do_move  = {
  unit;
  target;
}

and default_action_do_move_mutable () : action_do_move_mutable = {
  unit = None;
  target = None;
}

let rec default_action_do_affect 
  ?unit:((unit:program option) = None)
  ?affect_name:((affect_name:string option) = None)
  ?target:((target:position option) = None)
  () : action_do_affect  = {
  unit;
  affect_name;
  target;
}

and default_action_do_affect_mutable () : action_do_affect_mutable = {
  unit = None;
  affect_name = None;
  target = None;
}

let rec default_action_do_retire 
  ?retiree:((retiree:program_id option) = None)
  () : action_do_retire  = {
  retiree;
}

and default_action_do_retire_mutable () : action_do_retire_mutable = {
  retiree = None;
}

let rec default_action () : action = Move (default_action_do_move ())

let rec default_enemy_action 
  ?action:((action:action option) = None)
  ?game_state:((game_state:game_state option) = None)
  () : enemy_action  = {
  action;
  game_state;
}

and default_enemy_action_mutable () : enemy_action_mutable = {
  action = None;
  game_state = None;
}

let rec decode_affect_affect_type d = 
  let rec loop () = 
    let ret:affect_affect_type = match Pbrt.Decoder.key d with
      | None -> failwith "None of the known key is found"
      | Some (10, _) -> Damage (Pbrt.Decoder.int_as_varint d)
      | Some (11, _) -> Healing (Pbrt.Decoder.int_as_varint d)
      | Some (12, _) -> Floor (Pbrt.Decoder.bool d)
      | Some (13, _) -> Stepcap (Pbrt.Decoder.int_as_varint d)
      | Some (14, _) -> Sizecap (Pbrt.Decoder.int_as_varint d)
      | Some (n, payload_kind) -> (
        Pbrt.Decoder.skip d payload_kind; 
        loop () 
      )
    in
    ret
  in
  loop ()

and decode_affect d =
  let v = default_affect_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (10, Pbrt.Varint) -> (
      v.affect_type <- Damage (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (10, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(10)", pk))
    )
    | Some (11, Pbrt.Varint) -> (
      v.affect_type <- Healing (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (11, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(11)", pk))
    )
    | Some (12, Pbrt.Varint) -> (
      v.affect_type <- Floor (Pbrt.Decoder.bool d);
      loop ()
    )
    | Some (12, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(12)", pk))
    )
    | Some (13, Pbrt.Varint) -> (
      v.affect_type <- Stepcap (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (13, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(13)", pk))
    )
    | Some (14, Pbrt.Varint) -> (
      v.affect_type <- Sizecap (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (14, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(14)", pk))
    )
    | Some (1, Pbrt.Bytes) -> (
      v.name <- Some (Pbrt.Decoder.string d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.description <- Some (Pbrt.Decoder.string d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(2)", pk))
    )
    | Some (3, Pbrt.Varint) -> (
      v.size_cost <- Some (Pbrt.Decoder.int_as_zigzag d);
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(3)", pk))
    )
    | Some (4, Pbrt.Varint) -> (
      v.reqsize <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (4, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(4)", pk))
    )
    | Some (5, Pbrt.Varint) -> (
      v.range <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (5, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(affect), field(5)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:affect = Obj.magic v in
  v

let rec decode_player_id d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Player:player_id)
  | 1 -> (Enemy:player_id)
  | _ -> failwith "Unknown value for enum player_id"

let rec decode_program_id d =
  let v = default_program_id_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Varint) -> (
      v.player_id <- Some (decode_player_id d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program_id), field(1)", pk))
    )
    | Some (2, Pbrt.Varint) -> (
      v.unit_id <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program_id), field(2)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:program_id = Obj.magic v in
  v

let rec decode_position d =
  let v = default_position_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Varint) -> (
      v.x <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(position), field(1)", pk))
    )
    | Some (2, Pbrt.Varint) -> (
      v.y <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(position), field(2)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:position = Obj.magic v in
  v

let rec decode_program d =
  let v = default_program_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
      v.sectors <- List.rev v.sectors;
      v.affects <- List.rev v.affects;
    )
    | Some (1, Pbrt.Bytes) -> (
      v.name <- Some (Pbrt.Decoder.string d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.description <- Some (Pbrt.Decoder.string d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(2)", pk))
    )
    | Some (3, Pbrt.Bytes) -> (
      v.affects <- (decode_affect (Pbrt.Decoder.nested d)) :: v.affects;
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(3)", pk))
    )
    | Some (4, Pbrt.Varint) -> (
      v.move_rate <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (4, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(4)", pk))
    )
    | Some (5, Pbrt.Varint) -> (
      v.max_size <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (5, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(5)", pk))
    )
    | Some (6, Pbrt.Bytes) -> (
      v.program_id <- Some (decode_program_id (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (6, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(6)", pk))
    )
    | Some (7, Pbrt.Bytes) -> (
      v.sectors <- (decode_position (Pbrt.Decoder.nested d)) :: v.sectors;
      loop ()
    )
    | Some (7, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(program), field(7)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:program = Obj.magic v in
  v

let rec decode_cell d =
  let v = default_cell_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Varint) -> (
      v.passable <- Some (Pbrt.Decoder.bool d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(cell), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.unit_id <- Some (decode_program_id (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(cell), field(2)", pk))
    )
    | Some (3, Pbrt.Varint) -> (
      v.credit_value <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(cell), field(3)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:cell = Obj.magic v in
  v

let rec decode_grid d =
  let v = default_grid_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
      v.cells <- List.rev v.cells;
    )
    | Some (1, Pbrt.Varint) -> (
      v.width <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(grid), field(1)", pk))
    )
    | Some (2, Pbrt.Varint) -> (
      v.height <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(grid), field(2)", pk))
    )
    | Some (3, Pbrt.Bytes) -> (
      v.cells <- (decode_cell (Pbrt.Decoder.nested d)) :: v.cells;
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(grid), field(3)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:grid = Obj.magic v in
  v

let rec decode_game_state d =
  let v = default_game_state_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Varint) -> (
      v.current_player <- Some (decode_player_id d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(game_state), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.current_unit <- Some (decode_program_id (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(game_state), field(2)", pk))
    )
    | Some (3, Pbrt.Bytes) -> (
      v.grid <- Some (decode_grid (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(game_state), field(3)", pk))
    )
    | Some (4, Pbrt.Varint) -> (
      v.game_over <- Some (Pbrt.Decoder.bool d);
      loop ()
    )
    | Some (4, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(game_state), field(4)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:game_state = Obj.magic v in
  v

let rec decode_starting_state d =
  let v = default_starting_state_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
      v.starts <- List.rev v.starts;
      v.templates <- List.rev v.templates;
    )
    | Some (1, Pbrt.Bytes) -> (
      v.board <- Some (decode_grid (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(starting_state), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.templates <- (decode_program (Pbrt.Decoder.nested d)) :: v.templates;
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(starting_state), field(2)", pk))
    )
    | Some (3, Pbrt.Bytes) -> (
      v.starts <- (decode_position (Pbrt.Decoder.nested d)) :: v.starts;
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(starting_state), field(3)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:starting_state = Obj.magic v in
  v

let rec decode_player_configuration_program_selection d =
  let v = default_player_configuration_program_selection_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Bytes) -> (
      v.pos <- Some (decode_position (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(player_configuration_program_selection), field(1)", pk))
    )
    | Some (2, Pbrt.Varint) -> (
      v.selection_number <- Some (Pbrt.Decoder.int_as_varint d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(player_configuration_program_selection), field(2)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:player_configuration_program_selection = Obj.magic v in
  v

let rec decode_player_configuration d =
  let v = default_player_configuration_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
      v.selections <- List.rev v.selections;
    )
    | Some (1, Pbrt.Bytes) -> (
      v.selections <- (decode_player_configuration_program_selection (Pbrt.Decoder.nested d)) :: v.selections;
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(player_configuration), field(1)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:player_configuration = Obj.magic v in
  v

let rec decode_error d =
  let v = default_error_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Bytes) -> (
      v.description <- Some (Pbrt.Decoder.string d);
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(error), field(1)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:error = Obj.magic v in
  v

let rec decode_action_do_move d =
  let v = default_action_do_move_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Bytes) -> (
      v.unit <- Some (decode_program (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(action_do_move), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.target <- Some (decode_position (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(action_do_move), field(2)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:action_do_move = Obj.magic v in
  v

let rec decode_action_do_affect d =
  let v = default_action_do_affect_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Bytes) -> (
      v.unit <- Some (decode_program (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(action_do_affect), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.affect_name <- Some (Pbrt.Decoder.string d);
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(action_do_affect), field(2)", pk))
    )
    | Some (3, Pbrt.Bytes) -> (
      v.target <- Some (decode_position (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (3, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(action_do_affect), field(3)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:action_do_affect = Obj.magic v in
  v

let rec decode_action_do_retire d =
  let v = default_action_do_retire_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Bytes) -> (
      v.retiree <- Some (decode_program_id (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(action_do_retire), field(1)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:action_do_retire = Obj.magic v in
  v

let rec decode_action d = 
  let rec loop () = 
    let ret:action = match Pbrt.Decoder.key d with
      | None -> failwith "None of the known key is found"
      | Some (1, _) -> Move (decode_action_do_move (Pbrt.Decoder.nested d))
      | Some (2, _) -> Affect (decode_action_do_affect (Pbrt.Decoder.nested d))
      | Some (3, _) -> (Pbrt.Decoder.empty_nested d ; Undo)
      | Some (4, _) -> Retire (decode_action_do_retire (Pbrt.Decoder.nested d))
      | Some (n, payload_kind) -> (
        Pbrt.Decoder.skip d payload_kind; 
        loop () 
      )
    in
    ret
  in
  loop ()

let rec decode_enemy_action d =
  let v = default_enemy_action_mutable () in
  let rec loop () = 
    match Pbrt.Decoder.key d with
    | None -> (
    )
    | Some (1, Pbrt.Bytes) -> (
      v.action <- Some (decode_action (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (1, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(enemy_action), field(1)", pk))
    )
    | Some (2, Pbrt.Bytes) -> (
      v.game_state <- Some (decode_game_state (Pbrt.Decoder.nested d));
      loop ()
    )
    | Some (2, pk) -> raise (
      Protobuf.Decoder.Failure (Protobuf.Decoder.Unexpected_payload ("Message(enemy_action), field(2)", pk))
    )
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind; loop ()
  in
  loop ();
  let v:enemy_action = Obj.magic v in
  v

let rec encode_affect_affect_type (v:affect_affect_type) encoder = 
  match v with
  | Damage x -> (
    Pbrt.Encoder.key (10, Pbrt.Varint) encoder; 
    Pbrt.Encoder.int_as_varint x encoder;
  )
  | Healing x -> (
    Pbrt.Encoder.key (11, Pbrt.Varint) encoder; 
    Pbrt.Encoder.int_as_varint x encoder;
  )
  | Floor x -> (
    Pbrt.Encoder.key (12, Pbrt.Varint) encoder; 
    Pbrt.Encoder.bool x encoder;
  )
  | Stepcap x -> (
    Pbrt.Encoder.key (13, Pbrt.Varint) encoder; 
    Pbrt.Encoder.int_as_varint x encoder;
  )
  | Sizecap x -> (
    Pbrt.Encoder.key (14, Pbrt.Varint) encoder; 
    Pbrt.Encoder.int_as_varint x encoder;
  )

and encode_affect (v:affect) encoder = 
  (
    match v.affect_type with
    | Damage x -> (
      Pbrt.Encoder.key (10, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | Healing x -> (
      Pbrt.Encoder.key (11, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | Floor x -> (
      Pbrt.Encoder.key (12, Pbrt.Varint) encoder; 
      Pbrt.Encoder.bool x encoder;
    )
    | Stepcap x -> (
      Pbrt.Encoder.key (13, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | Sizecap x -> (
      Pbrt.Encoder.key (14, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
  );
  (
    match v.name with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.string x encoder;
    )
    | None -> ();
  );
  (
    match v.description with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.string x encoder;
    )
    | None -> ();
  );
  (
    match v.size_cost with 
    | Some x -> (
      Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_zigzag x encoder;
    )
    | None -> ();
  );
  (
    match v.reqsize with 
    | Some x -> (
      Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  (
    match v.range with 
    | Some x -> (
      Pbrt.Encoder.key (5, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_player_id (v:player_id) encoder =
  match v with
  | Player -> Pbrt.Encoder.int_as_varint (0) encoder
  | Enemy -> Pbrt.Encoder.int_as_varint 1 encoder

let rec encode_program_id (v:program_id) encoder = 
  (
    match v.player_id with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
      encode_player_id x encoder;
    )
    | None -> ();
  );
  (
    match v.unit_id with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_position (v:position) encoder = 
  (
    match v.x with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  (
    match v.y with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_program (v:program) encoder = 
  (
    match v.name with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.string x encoder;
    )
    | None -> ();
  );
  (
    match v.description with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.string x encoder;
    )
    | None -> ();
  );
  List.iter (fun x -> 
    Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_affect x) encoder;
  ) v.affects;
  (
    match v.move_rate with 
    | Some x -> (
      Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  (
    match v.max_size with 
    | Some x -> (
      Pbrt.Encoder.key (5, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  (
    match v.program_id with 
    | Some x -> (
      Pbrt.Encoder.key (6, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_program_id x) encoder;
    )
    | None -> ();
  );
  List.iter (fun x -> 
    Pbrt.Encoder.key (7, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_position x) encoder;
  ) v.sectors;
  ()

let rec encode_cell (v:cell) encoder = 
  (
    match v.passable with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
      Pbrt.Encoder.bool x encoder;
    )
    | None -> ();
  );
  (
    match v.unit_id with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_program_id x) encoder;
    )
    | None -> ();
  );
  (
    match v.credit_value with 
    | Some x -> (
      Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_grid (v:grid) encoder = 
  (
    match v.width with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  (
    match v.height with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  List.iter (fun x -> 
    Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_cell x) encoder;
  ) v.cells;
  ()

let rec encode_game_state (v:game_state) encoder = 
  (
    match v.current_player with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
      encode_player_id x encoder;
    )
    | None -> ();
  );
  (
    match v.current_unit with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_program_id x) encoder;
    )
    | None -> ();
  );
  (
    match v.grid with 
    | Some x -> (
      Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_grid x) encoder;
    )
    | None -> ();
  );
  (
    match v.game_over with 
    | Some x -> (
      Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
      Pbrt.Encoder.bool x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_starting_state (v:starting_state) encoder = 
  (
    match v.board with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_grid x) encoder;
    )
    | None -> ();
  );
  List.iter (fun x -> 
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_program x) encoder;
  ) v.templates;
  List.iter (fun x -> 
    Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_position x) encoder;
  ) v.starts;
  ()

let rec encode_player_configuration_program_selection (v:player_configuration_program_selection) encoder = 
  (
    match v.pos with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_position x) encoder;
    )
    | None -> ();
  );
  (
    match v.selection_number with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
      Pbrt.Encoder.int_as_varint x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_player_configuration (v:player_configuration) encoder = 
  List.iter (fun x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_player_configuration_program_selection x) encoder;
  ) v.selections;
  ()

let rec encode_error (v:error) encoder = 
  (
    match v.description with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.string x encoder;
    )
    | None -> ();
  );
  ()

let rec encode_action_do_move (v:action_do_move) encoder = 
  (
    match v.unit with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_program x) encoder;
    )
    | None -> ();
  );
  (
    match v.target with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_position x) encoder;
    )
    | None -> ();
  );
  ()

let rec encode_action_do_affect (v:action_do_affect) encoder = 
  (
    match v.unit with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_program x) encoder;
    )
    | None -> ();
  );
  (
    match v.affect_name with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.string x encoder;
    )
    | None -> ();
  );
  (
    match v.target with 
    | Some x -> (
      Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_position x) encoder;
    )
    | None -> ();
  );
  ()

let rec encode_action_do_retire (v:action_do_retire) encoder = 
  (
    match v.retiree with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_program_id x) encoder;
    )
    | None -> ();
  );
  ()

let rec encode_action (v:action) encoder = 
  match v with
  | Move x -> (
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_action_do_move x) encoder;
  )
  | Affect x -> (
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_action_do_affect x) encoder;
  )
  | Undo -> (
    Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.empty_nested encoder
  )
  | Retire x -> (
    Pbrt.Encoder.key (4, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_action_do_retire x) encoder;
  )

let rec encode_enemy_action (v:enemy_action) encoder = 
  (
    match v.action with 
    | Some x -> (
      Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_action x) encoder;
    )
    | None -> ();
  );
  (
    match v.game_state with 
    | Some x -> (
      Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
      Pbrt.Encoder.nested (encode_game_state x) encoder;
    )
    | None -> ();
  );
  ()

let rec pp_affect_affect_type fmt (v:affect_affect_type) =
  match v with
  | Damage x -> Format.fprintf fmt "@[Damage(%a)@]" Pbrt.Pp.pp_int x
  | Healing x -> Format.fprintf fmt "@[Healing(%a)@]" Pbrt.Pp.pp_int x
  | Floor x -> Format.fprintf fmt "@[Floor(%a)@]" Pbrt.Pp.pp_bool x
  | Stepcap x -> Format.fprintf fmt "@[Stepcap(%a)@]" Pbrt.Pp.pp_int x
  | Sizecap x -> Format.fprintf fmt "@[Sizecap(%a)@]" Pbrt.Pp.pp_int x

and pp_affect fmt (v:affect) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "affect_type" pp_affect_affect_type fmt v.affect_type;
    Pbrt.Pp.pp_record_field "name" (Pbrt.Pp.pp_option Pbrt.Pp.pp_string) fmt v.name;
    Pbrt.Pp.pp_record_field "description" (Pbrt.Pp.pp_option Pbrt.Pp.pp_string) fmt v.description;
    Pbrt.Pp.pp_record_field "size_cost" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.size_cost;
    Pbrt.Pp.pp_record_field "reqsize" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.reqsize;
    Pbrt.Pp.pp_record_field "range" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.range;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_player_id fmt (v:player_id) =
  match v with
  | Player -> Format.fprintf fmt "Player"
  | Enemy -> Format.fprintf fmt "Enemy"

let rec pp_program_id fmt (v:program_id) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "player_id" (Pbrt.Pp.pp_option pp_player_id) fmt v.player_id;
    Pbrt.Pp.pp_record_field "unit_id" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.unit_id;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_position fmt (v:position) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "x" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.x;
    Pbrt.Pp.pp_record_field "y" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.y;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_program fmt (v:program) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "name" (Pbrt.Pp.pp_option Pbrt.Pp.pp_string) fmt v.name;
    Pbrt.Pp.pp_record_field "description" (Pbrt.Pp.pp_option Pbrt.Pp.pp_string) fmt v.description;
    Pbrt.Pp.pp_record_field "affects" (Pbrt.Pp.pp_list pp_affect) fmt v.affects;
    Pbrt.Pp.pp_record_field "move_rate" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.move_rate;
    Pbrt.Pp.pp_record_field "max_size" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.max_size;
    Pbrt.Pp.pp_record_field "program_id" (Pbrt.Pp.pp_option pp_program_id) fmt v.program_id;
    Pbrt.Pp.pp_record_field "sectors" (Pbrt.Pp.pp_list pp_position) fmt v.sectors;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_cell fmt (v:cell) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "passable" (Pbrt.Pp.pp_option Pbrt.Pp.pp_bool) fmt v.passable;
    Pbrt.Pp.pp_record_field "unit_id" (Pbrt.Pp.pp_option pp_program_id) fmt v.unit_id;
    Pbrt.Pp.pp_record_field "credit_value" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.credit_value;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_grid fmt (v:grid) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "width" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.width;
    Pbrt.Pp.pp_record_field "height" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.height;
    Pbrt.Pp.pp_record_field "cells" (Pbrt.Pp.pp_list pp_cell) fmt v.cells;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_game_state fmt (v:game_state) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "current_player" (Pbrt.Pp.pp_option pp_player_id) fmt v.current_player;
    Pbrt.Pp.pp_record_field "current_unit" (Pbrt.Pp.pp_option pp_program_id) fmt v.current_unit;
    Pbrt.Pp.pp_record_field "grid" (Pbrt.Pp.pp_option pp_grid) fmt v.grid;
    Pbrt.Pp.pp_record_field "game_over" (Pbrt.Pp.pp_option Pbrt.Pp.pp_bool) fmt v.game_over;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_starting_state fmt (v:starting_state) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "board" (Pbrt.Pp.pp_option pp_grid) fmt v.board;
    Pbrt.Pp.pp_record_field "templates" (Pbrt.Pp.pp_list pp_program) fmt v.templates;
    Pbrt.Pp.pp_record_field "starts" (Pbrt.Pp.pp_list pp_position) fmt v.starts;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_player_configuration_program_selection fmt (v:player_configuration_program_selection) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "pos" (Pbrt.Pp.pp_option pp_position) fmt v.pos;
    Pbrt.Pp.pp_record_field "selection_number" (Pbrt.Pp.pp_option Pbrt.Pp.pp_int) fmt v.selection_number;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_player_configuration fmt (v:player_configuration) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "selections" (Pbrt.Pp.pp_list pp_player_configuration_program_selection) fmt v.selections;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_error fmt (v:error) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "description" (Pbrt.Pp.pp_option Pbrt.Pp.pp_string) fmt v.description;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_action_do_move fmt (v:action_do_move) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "unit" (Pbrt.Pp.pp_option pp_program) fmt v.unit;
    Pbrt.Pp.pp_record_field "target" (Pbrt.Pp.pp_option pp_position) fmt v.target;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_action_do_affect fmt (v:action_do_affect) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "unit" (Pbrt.Pp.pp_option pp_program) fmt v.unit;
    Pbrt.Pp.pp_record_field "affect_name" (Pbrt.Pp.pp_option Pbrt.Pp.pp_string) fmt v.affect_name;
    Pbrt.Pp.pp_record_field "target" (Pbrt.Pp.pp_option pp_position) fmt v.target;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_action_do_retire fmt (v:action_do_retire) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "retiree" (Pbrt.Pp.pp_option pp_program_id) fmt v.retiree;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_action fmt (v:action) =
  match v with
  | Move x -> Format.fprintf fmt "@[Move(%a)@]" pp_action_do_move x
  | Affect x -> Format.fprintf fmt "@[Affect(%a)@]" pp_action_do_affect x
  | Undo  -> Format.fprintf fmt "Undo"
  | Retire x -> Format.fprintf fmt "@[Retire(%a)@]" pp_action_do_retire x

let rec pp_enemy_action fmt (v:enemy_action) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "action" (Pbrt.Pp.pp_option pp_action) fmt v.action;
    Pbrt.Pp.pp_record_field "game_state" (Pbrt.Pp.pp_option pp_game_state) fmt v.game_state;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()
