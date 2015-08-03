module O = Spyboat_objects

open Core.Std
open Yojson
open Yojson.Basic.Util

let affect_from_name affects nameobj =
  let name = nameobj |> to_string in

  let same_name affect = 
    (String.compare name (O.get_affect_name affect) = 0)
  in

  let opt = List.find ~f:same_name affects in
  match opt with
  | Some(res) -> res
  | None -> raise (Invalid_argument ("No such affect: " ^ name ^ "."))

let unit_from_name units name =
  let same_name gunit = 
    (String.compare name (O.get_baseunit_name gunit) = 0)
  in

  let opt = List.find ~f:same_name units in
  match opt with
  | Some(res) -> res
  | None -> raise (Invalid_argument ("No such affect: " ^ name ^ "."))

let to_pos_list lst = 
  let make_pos el =
    let x = el |> member "x" |> to_int in
    let y = el |> member "y" |> to_int in
    (x, y)
  in
  List.map ~f:make_pos lst

let affects_from_file path =

  let get_affect_type name magnitude =
    if ((String.compare name "health") = 0) then
      O.HEALTH(magnitude)

    else if ((String.compare name "floor") = 0) then
      let floor =
        match magnitude with
      | 0 -> false
      | _ -> true
      in

      O.FLOOR(floor)

    else if ((String.compare name "stepcap") = 0) then
      O.STEPCAP(magnitude)

    else if ((String.compare name "sizecap") = 0) then
      O.SIZECAP(magnitude)

    else
      raise (Invalid_argument ("No such affect type: " ^ name ^ "."))
  in

  let get_affect item =
    let name = item |> member "name" |> to_string in
    let desc = item |> member "description" |> to_string in
    let atype = item |> member "type" |> to_string in
    let magnitude = item |> member "magnitude" |> to_int in
    let atype = get_affect_type atype magnitude in
    let range = item |> member "range" |> to_int in
    let reqsize = item |> member "requiredSize" |> to_int in
    let sizecost = item |> member "cost" |> to_int in
    O.Affect(name, desc, atype, sizecost, reqsize, range)
  in 

  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let affects_lst = js |> member "affects" |> to_list in

  List.map ~f:get_affect affects_lst

let units_from_file path affects =
  let get_unit item =
    let name = item |> member "name" |> to_string in
    let desc = item |> member "description" |> to_string in
    let moveRate = item |> member "moveRate" |> to_int in
    let maxSize = item |> member "maxSize" |> to_int in
    let attacks = item |> member "attacks" |> to_list in
    let attacks = List.map ~f:(affect_from_name affects) attacks in
    O.UnitTemplate(name, desc, attacks, maxSize, moveRate)
  in 

  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let unit_lst = js |> member "units" |> to_list in

  List.map ~f:get_unit unit_lst

let map_from_file path units affects =
  let get_unit el = 
    let name = el |> member "name" |> to_string in
    let baseunit = unit_from_name units name in
    let sectors = el |> member "sectors" |> to_list in
    let sectors = to_pos_list sectors in
    O.make_unit baseunit sectors
  in

  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let width = js |> member "width" |> to_int in
  let height = js |> member "height" |> to_int in
  let spawns = js |> member "spawn-points" |> to_list in
  let enemies = js |> member "units" |> to_list in
  let cells = js |> member "cells" |> to_list in
  let baseCell = O.Cell(false, 1, None) in
  let gameCells =
    Array.make_matrix ~dimx:height ~dimy:width baseCell in

  let fillCells i str =
    let addArr j c =
      let add = 
        match c with
        | ' ' -> false
        | _ -> true
      in

      let newcell = O.Cell(add, 1, None) in

      gameCells.(i).(j) <- newcell
    in

    let chars = String.to_list (str |> to_string) in
    List.iteri ~f:addArr chars
  in

  let _ = List.iteri ~f:fillCells cells in

  let spawns = to_pos_list spawns in

  let enemies = List.map ~f:get_unit enemies in

  O.Map(width, height, gameCells, spawns, enemies)
