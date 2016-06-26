module O = Spyboat_objects

val affects_from_file :
  string -> O.Affect.t list

val units_from_file :
  string -> O.Affect.t list -> O.UnitTemplate.t list

val map_from_file :
  string -> O.UnitTemplate.t list -> O.Affect.t list -> O.Map.t
