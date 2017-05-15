val affects_from_file :
  string -> Message_pb.affect list

val units_from_file :
  string -> Message_pb.affect list -> Message_pb.program list

val map_from_file :
  string -> Message_pb.program list -> Message_pb.affect list -> Message_pb.starting_state

val next_id : Message_pb.player_id -> Message_pb.program_id
