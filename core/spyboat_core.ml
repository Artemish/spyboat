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

  let make_unit (selection : player_configuration_program_selection) = 
    let {position; selection_number} = selection in
    
    position >>= (fun pos ->
    selection_number >>= (fun select ->
    List.nth templates select >>= (fun template ->
      let program_id = Some(Spyboat_templates.next_id Player) in
      let sectors = [pos] in
      return {template with program_id; sectors})))
  in

  let player_units = List.map ~f:make_unit selections in

  let Some({cells; width}) = grid in
  let arr = Pbrt.Repeated_field.to_array cells in

  let update_grid program =
    let f pos =
      pos.x >>= (fun x ->
      pos.y >>= (fun y ->
      width >>= (fun w ->
      let cell = Array.get arr (x+y*w) in
      return (Array.set arr (x+y*w) {cell with program_id = program.program_id}))))
    in List.map ~f program.sectors
  in

  List.map ~f:update_grid player_units;
  List.map ~f:update_grid enemies;

  let new_grid = Pbrt.Repeated_field.of_array arr in

  
  let start :: _ = player_units in 

  start.program_id >>= (fun pid -> 
    return (default_game ~grid:new_grid ~current_unit:pid ~current_player:Some(Message_pb.Player)))
