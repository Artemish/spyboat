let affects = Templates.affects_from_file "affects.json" in
let units = Templates.units_from_file "units.json" affects in
let map = Templates.map_from_file "demo-level.json" units affects in
()
