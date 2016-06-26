module O = Spyboat_objects 

val get_map: unit ->
             (O.Affect.t list *
              O.UnitTemplate.t list *
              O.Map.t)

val initialize_board: affects: O.Affect.t list ->
                      templates: O.UnitTemplate.t list -> 
                      map: O.Map.t ->
                      choices: (O.position * string) list ->
                      O.BoardState.t
