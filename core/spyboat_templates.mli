open Spyboat_objects

val affects_from_file :
  string -> Spyboat_objects.affect list

val units_from_file :
  string -> Spyboat_objects.affect list -> Spyboat_objects.baseunit list

val map_from_file :
  string -> Spyboat_objects.baseunit list -> Spyboat_objects.affect list -> Spyboat_objects.map
