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
  (* Template, sector list, current move rate, size, active *)
  (baseunit * position list * int * int * bool)
and cell = 
  Cell of (bool * int * credit list)
and credit =
  Credit of int

let get_affect_name affect = 
  let Affect(name, _, _, _, _, _) = affect in
  name
