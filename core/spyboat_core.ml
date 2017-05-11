open Core.Std 
open Option
open Message_pb

let get_starting_state () = 
  let affects = Spyboat_templates.affects_from_file "res/affects.json" in
  let units = Spyboat_templates.units_from_file "res/units.json" affects in
  Spyboat_templates.map_from_file "res/demo-level.json" 

let initialize_board starting_state player_configuration =

  let {grid; templates; starts; affects; enemies} = starting_state in

  let {selections} = player_configuration in

  let make_unit selection = 
    let {position; selection_number} = selection in
    position >>= (fun pos -> selection_number >>= (fun select ->
      let template = List.nth_exn select templates in
      let program_id = Some(Spyboat_templates.next_id Player) in
      let sectors = [pos] in
      return {template with program_id; sectors}))

  let to_unitstate: (position * string) -> O.UnitState.t =
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
