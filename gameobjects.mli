type baseunit =
  (* Name, description, affects, base size, base moverate *)
  UnitTemplate of (string * string * affect list * int * int)
and affect =
  (* Name, description, affect type, cost, required size, range*)
  Affect of (string * string * affecttype * int * int * int)
and affecttype = 
    HEALTH of int
  | FLOOR of bool
  | STEPCAP of int
  | SIZECAP of int
and position = (int * int)
and unitstate =
  (* Template, sector list, max size, move rate, active *)
  (baseunit * position list * int * int * bool)
and cell = 
  Cell of (bool * int * credit list)
and credit =
  Credit of int
and map =
  Map of (int * int * cell array array * position list * unitstate list)

val get_affect_name : affect -> string
val get_baseunit_name : baseunit -> string
val make_unit : baseunit -> position list -> unitstate
