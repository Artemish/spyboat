open Core.Std
open Yojson
open Gameobjects

let affects_from_file path =
  let get_affect_type name magnitude =
    if ((String.compare name "health") = 0) then
      HEALTH(magnitude)
    else if ((String.compare name "floor") = 0) then
      let floor =
        match magnitude with
        | 0 -> false
        | _ -> true
      in
      FLOOR(floor)
    else if ((String.compare name "stepcap") = 0) then
      STEPCAP(magnitude)
    else if ((String.compare name "sizecap") = 0) then
      SIZECAP(magnitude)
    else
      raise (Invalid_argument ("No such affect type: " ^ name ^ "."))
  in

  let open Yojson.Basic.Util in
  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let affects_lst = js |> member "affects" |> to_list in
  let get_affect item =
    let name = item |> member "name" |> to_string in
    let desc = item |> member "description" |> to_string in
    let atype = item |> member "type" |> to_string in
    let magnitude = item |> member "magnitude" |> to_int in
    let atype = get_affect_type atype magnitude in
    let range = item |> member "range" |> to_int in
    let reqsize = item |> member "requiredSize" |> to_int in
    let sizecost = item |> member "cost" |> to_int in
    Affect(name, desc, atype, sizecost, reqsize, range)
  in 
  List.map ~f:get_affect affects_lst

let units_from_file path affects =
  let open Yojson.Basic.Util in
  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let unit_lst = js |> member "units" |> to_list in
  let get_unit item =
    let name = item |> member "name" |> to_string in
    let desc = item |> member "description" |> to_string in
    let moveRate = item |> member "moveRate" |> to_int in
    let maxSize = item |> member "maxSize" |> to_int in
    let attacks = item |> member "attacks" |> to_list in
    let affect_from_name nameobj =
      let name = nameobj |> to_string in
      let same_name affect = 
        (String.compare name (get_affect_name affect) = 0)
      in
      let opt = List.find ~f:same_name affects in
      match opt with
      | Some(res) -> res
      | None -> raise (Invalid_argument ("No such affect: " ^ name ^ "."))
    in
    let attacks = List.map ~f:affect_from_name attacks in
    UnitTemplate(name, desc, attacks, maxSize, moveRate)
  in 
  List.map ~f:get_unit unit_lst

let map_from_file path units affects =
  let open Yojson.Basic.Util in
  let buf = In_channel.read_all path in
  let js = Yojson.Basic.from_string buf in
  let width = js |> member "width" |> to_int in
  let height = js |> member "height" |> to_int in
  let spawns = js |> member "spawn-points" |> to_list in
  let units = js |> member "units" |> to_list in
  let cells = js |> member "cells" |> to_list in
  let baseCell = Cell(false, 1, []) in
  let gameCells =
    Array.make_matrix ~dimx:height ~dimy:width baseCell in
  let fillCells i str =
    let addArr j c =
      let add = 
        match c with
        | ' ' -> false
        | _ -> true
      in
      let newcell = Cell(add, 1, []) in
      gameCells.(i).(j) <- newcell
    in
    let chars = String.to_list (str |> to_string) in
    List.iteri ~f:addArr chars
  in
  List.iteri ~f:fillCells cells;

  gameCells
