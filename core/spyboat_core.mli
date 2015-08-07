val get_map: unit ->
             (Spyboat_objects.affect list *
              Spyboat_objects.baseunit list *
              Spyboat_objects.map)

val initialize_map: Spyboat_objects.affect list ->
                    Spyboat_objects.baseunit list -> 
                    Spyboat_objects.map ->
                   (Spyboat_objects.position * string) list ->
                    Spyboat_objects.boardstate
