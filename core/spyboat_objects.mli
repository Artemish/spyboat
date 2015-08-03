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
  (* Template, sector list, max size, move rate, active *)
  (baseunit * position list * int * int * bool)

type cell = 
  Cell of (bool * int * credit option)

type map =
  Map of (int * int * cell array array * position list * unitstate list)

val get_affect_name : affect -> string
val get_baseunit_name : baseunit -> string
val make_unit : baseunit -> position list -> unitstate
