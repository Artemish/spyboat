open Core.Std

type unit_id = UID of int

(* TODO use real IDs *)
type player_id = 
  | Player
  | Enemy

type position = (int * int)
type credit = Credit of int

module Affect = struct
  type affecttype = 
    | DAMAGE of int
    | HEALING of int
    | FLOOR of bool
    | STEPCAP of int
    | SIZECAP of int

  type t = {
    name: string;
    descr: string;
    atype: affecttype;
    cost: int;
    reqsize: int;
    range: int;
  } [@@deriving fields]
end

module UnitTemplate = struct
  type t = {
    name: string;
    descr: string;
    affects: Affect.t list;
    base_size: int;
    base_move: int;
  } [@@deriving fields]
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
  } [@@deriving fields]

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
  } [@@deriving fields]
end
  
module Map = struct
  type t = {
    width: int;
    height: int;
    cells: Cell.t array array;
    starts: position list;
    enemy_units: UnitState.t list;
  } [@@deriving fields]
end

module BoardState = struct
  type t = {
    width: int;
    height: int;
    cells: Cell.t array array;
    player_units: UnitState.t list;
    enemy_units: UnitState.t list;
  } [@@deriving fields]
end

let get_affect_name {name} : Affect.t = name

let get_baseunit_name {name} : UnitTemplate.t = name

let string_of_affect {name; descr} : Affect.t =
  name ^ ": " ^ desc

let find_unit units name =
  let same_name gunit =
    (String.compare name (get_baseunit_name gunit) = 0)
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
