open Core.Std

type unit_id = UID of int [@@deriving yojson]

(* TODO use real IDs *)
type player_id = 
  | Player
  | Enemy
  [@@deriving yojson]

type position = (int * int) [@@deriving yojson]
type credit = Credit of int [@@deriving yojson]

module Affect = struct
  type affecttype = 
    | DAMAGE of int
    | HEALING of int
    | FLOOR of bool
    | STEPCAP of int
    | SIZECAP of int
    [@@deriving yojson]

  type t = {
    name: string;
    descr: string;
    atype: affecttype;
    cost: int;
    reqsize: int;
    range: int;
  } [@@deriving fields, yojson]
end

module UnitTemplate = struct
  type t = {
    name: string;
    descr: string;
    affects: Affect.t list;
    base_size: int;
    base_move: int;
  } [@@deriving fields, yojson]
end

module UnitState = struct
  type t = {
    template: UnitTemplate.t;
    pid: player_id;
    uid: unit_id;
    head: position;
    sectors: position list;
    max_size: int;
    move_rate: int;
  } [@@deriving fields, yojson]

  let nextUID = ref 0

  let create ~template ~sectors ~pid =
    let max_size = UnitTemplate.base_size template in
    let move_rate = UnitTemplate.base_move template in
    let uid = UID(!nextUID) in
    let () = incr nextUID in
    {template; pid; uid; head = List.hd_exn sectors; sectors; max_size; move_rate}
end

module Cell = struct
  type t = {
    passable: bool;
    uid_opt: unit_id option;
    credit_opt: credit option;
  } [@@deriving fields, yojson]
end
  
module Map = struct
  type t = {
    width: int;
    height: int;
    cells: Cell.t array array;
    starts: position list;
    enemy_units: UnitState.t list;
  } [@@deriving fields, yojson]
end

module BoardState = struct
  type t = {
    width: int;
    height: int;
    cells: Cell.t array array;
    player_units: UnitState.t list;
    enemy_units: UnitState.t list;
  } [@@deriving fields, yojson]
end

let get_affect_name affect = Affect.name affect

let get_template_name template = UnitTemplate.name template

let string_of_affect affect =
  (Affect.name affect) ^ ": " ^ (Affect.descr affect)

let find_template units name =
  let same_name gunit =
    (String.compare name (get_template_name gunit) = 0)
  in

  match (List.find ~f:same_name units) with
  | Some res -> res
  | None -> raise (Invalid_argument("No such unit: " ^ name ^ "."))

let find_affect affects name =
  let same_name gaffect =
    (String.compare name (get_affect_name gaffect) = 0)
  in

  match (List.find ~f:(fun x -> get_affect_name x = name) affects) with
  | Some res -> res
  | None -> raise (Invalid_argument("No such affect: " ^ name ^ "."))

let char_of_uuid (UID(i)) =
  match Char.of_int (i + 0x30) with
    None -> '`' (* hacks lol *)
  | Some(c) -> c
