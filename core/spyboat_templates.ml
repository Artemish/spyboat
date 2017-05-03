open Core.Std
open Message_pb
open Yojson
open Yojson.Basic.Util

let to_some s = Some(s)

let to_pos_list lst = 
  let make_pos el =
    let x = el |> member "x" |> to_int |> to_some in
    let y = el |> member "y" |> to_int |> to_some in
    default_position ~x ~y ()
  in
  List.map ~f:make_pos lst

let affects_from_file path =
  let get_affect_type name magnitude =
    if (name = "damage") then
      Damage(magnitude)

    else if (name = "health") then
      Healing(magnitude)

    else if (name = "floor") then
      let floor =
        match magnitude with
      | 0 -> false
      | _ -> true
      in

      Floor(floor)

    else if (name = "stepcap") then
      Stepcap(magnitude)

    else if (name = "sizecap") then
      Sizecap(magnitude)

    else
      raise (Invalid_argument ("No such affect type: " ^ name ^ "."))
  in

  let get_affect item =
    let atype_string = item |> member "type" |> to_string in
    let magnitude = item |> member "magnitude" |> to_int in
    let affect_type = get_affect_type atype_string magnitude in

    let name = item |> member "name" |> to_string |> to_some in
    let description = item |> member "description" |> to_string |> to_some in
    let range = item |> member "range" |> to_int |> to_some in
    let reqsize = item |> member "requiredSize" |> to_int |> to_some in
    let size_cost = item |> member "cost" |> to_int |> to_some in

    default_affect ~affect_type ~name ~description ~reqsize ~range ~size_cost ()
  in

  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let affects_lst = js |> member "affects" |> to_list in

  List.map ~f:get_affect affects_lst

let units_from_file path affects =
  let get_unit item =
    let name = item |> member "name" |> to_string |> to_some in
    let description = item |> member "description" |> to_string |> to_some in
    let move_rate = item |> member "moveRate" |> to_int |> to_some in
    let max_size = item |> member "maxSize" |> to_int |> to_some in
    let attacks = item |> member "attacks" |> to_list in
    let attack_names = List.map ~f:to_string attacks in

    let same_name name (affect : affect) = Some(name) = affect.name in
    let get_affect_from_name name affects = List.find_exn ~f:(same_name name) affects in
    let affect = List.map ~f:(get_affect_from_name) attack_names in

    default_program ~name ~description ~affects ~move_rate ~max_size () 
  in 

  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let unit_lst = js |> member "units" |> to_list in

  List.map ~f:get_unit unit_lst

let current_id = ref 1

let next_id player_id =
  let player_id = Some(player_id) in
  let unit_id = Some(!current_id) in
  let () = incr current_id in
  default_program_id ~player_id ~unit_id () 

let map_from_file path programs affects =
  let get_unit el = 
    let name = el |> member "name" |> to_string in
    let sectors = el |> member "sectors" |> to_list in
    let sectors = to_pos_list sectors in
    let program_id = Some(next_id Enemy) in

    let same_name name (program : program) = program.name = Some(name) in
    let program = List.find_exn ~f:(same_name name) programs in
    { program with sectors; program_id }
  in

  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let width = js |> member "width" |> to_int in
  let height = js |> member "height" |> to_int in
  let spawns = js |> member "spawn-points" |> to_list in
  let enemies = js |> member "units" |> to_list in
  let cell_list = js |> member "cells" |> to_list in

  let make_cell i = default_cell ~passable(List.nth_exn cell_list i = 1) () in
  let cells = List.map ~f:make_cell  (List.range 0 (width * height)) in

  let starts = to_pos_list spawns in

  let enemy_units = List.map ~f:get_unit enemies in

  create ~width ~height ~cells ~starts ~enemy_units
