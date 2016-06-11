module T = Spyboat_templates
module O = Spyboat_objects

open Core.Std 

let get_map () = 
  let affects = T.affects_from_file "res/affects.json" in
  let units = T.units_from_file "res/units.json" affects in
  let map = T.map_from_file "res/demo-level.json" units affects in
  (affects, units, map)

let initialize_board affects units map unit_selection = 
  let O.Map(width, height, cell_arr, starting_pos, enemies) = map in

  let to_unitstate: (O.position * string) -> O.unitstate =
    fun (pos, unit_name) ->
      let () =
        match (List.mem starting_pos pos) with
        | false -> raise (Invalid_argument("No position"))
        | true -> ()
      in
      
      let base_unit = O.find_unit units unit_name in

      (* TODO treat this properly *)
      O.make_unit base_unit [pos] O.Player
  in

  let player_units = List.map ~f:to_unitstate unit_selection in
  (* TODO check starting position duplicates *)

  let update_arr units =
    let register_position uid (x, y) =
      let row = Array.get cell_arr y in
      let O.Cell(passable, _, credit) = Array.get row x in
      let newcell = O.Cell(passable, Some(uid), credit) in
      cell_arr.(y).(x) <- newcell
    in

    let register_unit (O.Boat(_, _, uid, _, sectors, _, _)) = 
      List.iter ~f:(register_position uid) sectors
    in

    List.iter ~f:register_unit player_units;
    List.iter ~f:register_unit enemies
  in


  let () = update_arr units in

  (* TODO check empty *)
  let start :: _ = player_units in 

  O.Board(width, height, cell_arr, player_units, enemies)
