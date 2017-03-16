open Core.Std

type unit_id = UID of int [@@deriving yojson]

(* TODO use real IDs *)
type player_id = 
  | Player
  | Enemy
  [@@deriving yojson]

type position = (int * int) [@@deriving yojson]
type credit = Credit of int [@@deriving yojson]

module Affect : sig
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

module UnitTemplate : sig
  type t = {
    name: string;
    descr: string;
    affects: Affect.t list;
    base_size: int;
    base_move: int;
  } [@@deriving fields, yojson]
end

module UnitState : sig 
  type t = {
    template: UnitTemplate.t;
    pid: player_id;
    uid: unit_id;
    head: position;
    sectors: position list;
    max_size: int;
    move_rate: int;
  } [@@deriving fields, yojson]

  val create : template:UnitTemplate.t -> sectors:(position list) -> pid:player_id -> t
end 

module Cell : sig 
  type t = {
    passable: bool;
    uid_opt: unit_id option;
    credit_opt: credit option;
  } [@@deriving fields, yojson]
end
  
module Map : sig 
  type t = {
    width: int;
    height: int;
    cells: Cell.t array array;
    starts: position list;
    enemy_units: UnitState.t list;
  } [@@deriving fields, yojson]
end

module BoardState : sig 
  type t = {
    width: int;
    height: int;
    cells: Cell.t array array;
    player_units: UnitState.t list;
    enemy_units: UnitState.t list;
  } [@@deriving fields, yojson]
end

val get_affect_name : Affect.t -> string
val string_of_affect : Affect.t -> string

val get_template_name : UnitTemplate.t -> string
val find_template : UnitTemplate.t list -> string -> UnitTemplate.t

val find_affect : Affect.t list -> string -> Affect.t

val char_of_uuid : unit_id -> char
