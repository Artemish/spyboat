module T = Spyboat_templates
module O = Spyboat_objects

open Core.Std 

let get_map () = 
  let affects = T.affects_from_file "res/affects.json" in
  let units = T.units_from_file "res/units.json" affects in
  let map = T.map_from_file "res/demo-level.json" units affects in
  (affects, units, map)

let initialize_map affects units map unit_selection = 
  let O.Map(width, height, cell_arr, starting_pos, enemies) = map in

  let to_unitstate: (O.position * string) -> O.unitstate =
    fun (pos, unit_name) ->
      let () =
        match (List.mem starting_pos pos) with
        | false -> print_string "Hello!\n";
                   raise (Invalid_argument("No position"))
        | true -> ()
      in
      
      let base_unit = O.find_unit units unit_name in

      O.make_unit base_unit [pos]
  in

  let player_units = List.map ~f:to_unitstate unit_selection in

  (* TODO populate cells with unit IDs, mirror structures *)

  O.Board(width, height, cell_arr, player_units, enemies)
