module T = Spyboat_templates
let get_map () = 
  let affects = T.affects_from_file "../res/affects.json" in
  let units = T.units_from_file "../res/units.json" affects in
  T.map_from_file "../res/demo-level.json" units affects
