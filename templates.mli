open Core.Std
open Yojson
open Gameobjects

val affects_from_file :
  string -> affect list

val units_from_file :
  string -> affect list -> baseunit list
