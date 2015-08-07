module C = Spyboat_core
module O = Spyboat_objects

open Core.Std

let main = fun () ->
  let (affects, units, map) = C.get_map () in
  let choice =
    [(6, 1), "Hack 3.0"]
  in
  let O.Map(_, _, _, starts, _) = map in
  let () =
    List.iter ~f:(fun (x, y) -> print_string ("(" ^ string_of_int x ^ ", " ^ string_of_int y ^ ")\n")) starts
  in

  let b = C.initialize_map affects units map choice in
  b

let b = main ()
