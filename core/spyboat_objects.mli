open Core.Std

type uuid =
  UUID of int

type affecttype = 
  | HEALTH of int
  | FLOOR of bool
  | STEPCAP of int
  | SIZECAP of int

type credit =
  Credit of int

type position = (int * int)

type affect =
    (* Name, description, affect type, cost, required size, range*)
    Affect of (string * string * affecttype * int * int * int)

type baseunit =
    (* Name, description, affects, base size, base moverate *)
    UnitTemplate of (string * string * affect list * int * int)

type unitstate =
  (* Template, uid, head position, sector list, max size, move rate *)
  Boat of (baseunit * uuid * position * position list * int * int)

type cell = 
  Cell of (bool * uuid option * credit option)

(* Width, height, 2d array of cells, starting positions, enemies *)
type map =
  Map of (int * int * cell array array * position list * unitstate list)

(* Width, height, 2d array of cells, player units, enemy units *)
type boardstate =
  Board of (int * int * cell array array * unitstate list * unitstate list)

val get_affect_name : affect -> string
val find_affect : affect list -> string -> affect
val get_baseunit_name : baseunit -> string
val make_unit : baseunit -> position list -> unitstate
val find_unit : baseunit list -> string -> baseunit
val char_of_uuid : uuid -> char
val string_of_affect : affect -> string
