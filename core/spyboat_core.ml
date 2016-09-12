module T = Spyboat_templates
module O = Spyboat_objects

open Core.Std 

let get_map () = 
  let affects = T.affects_from_file "res/affects.json" in
  let units = T.units_from_file "res/units.json" affects in
  let map = T.map_from_file "res/demo-level.json" units affects in
  (affects, units, map)

let initialize_board ~affects ~templates ~map ~choices = 
  let module M = O.Map in
  let module C = O.Cell in
  let module U = O.UnitState in
  let module T = O.UnitTemplate in

  let {M.width; M.height; M.cells; M.starts; M.enemy_units} = map in

  let to_unitstate: (O.position * string) -> O.UnitState.t =
    fun (pos, unit_name) ->
      let () =
        match (List.mem starts pos) with
        | false -> raise (Invalid_argument("No position"))
        | true -> ()
      in
      
      let template = List.find_exn ~f:(fun x -> T.name x = unit_name) templates in

      (* TODO treat this properly *)
      U.create ~template ~sectors:[pos] ~pid:O.Player
  in

  let player_units = List.map ~f:to_unitstate choices in
  (* TODO check starting position duplicates *)

  let register_position uid (x, y) =
    let newcell = {cells.(y).(x) with uid_opt = Some(uid)} in
    cells.(y).(x) <- newcell
  in

  let register_unit {U.uid; U.sectors} = 
    List.iter ~f:(register_position uid) sectors
  in

  List.iter ~f:register_unit player_units;
  List.iter ~f:register_unit enemy_units;

  (* TODO check empty *)
  let start :: _ = player_units in 

  O.BoardState.Fields.create ~width ~height ~cells ~player_units ~enemy_units
