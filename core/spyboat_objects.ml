open Core.Std

type uuid =
  UUID of int

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
  Boat of (baseunit * uuid * position list * int * int * bool)

and cell = 
  Cell of (bool * uuid option * credit option)

and credit =
  Credit of int
  
and map =
  Map of (int * int * cell array array * position list * unitstate list)

and boardstate =
  Board of (int * int * cell array array * unitstate list * unitstate list)


let nextUUID = ref 0

let get_affect_name affect = 
  let Affect(name, _, _, _, _, _) = affect in
  name

let get_baseunit_name baseunit = 
  let UnitTemplate(name, _, _, _, _) = baseunit in
  name

let make_unit baseunit sectors =
  let UnitTemplate(_, _, _, maxsize, moverate) = baseunit in
  let uuid = UUID(!nextUUID) in
  let () = incr nextUUID in
  Boat(baseunit, uuid, sectors, maxsize, moverate, false)

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

  match (List.find ~f:same_name affects) with
  | Some res -> res
  | None -> raise (Invalid_argument("No such affect: " ^ name ^ "."))
