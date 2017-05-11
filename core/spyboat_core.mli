val get_map: unit -> Message_pb.starting_state

val initialize_board: starting_state: Message_pb.starting_state ->
                      configuration: Message_pb.player_configuration ->
                      Message_pb.game_state
