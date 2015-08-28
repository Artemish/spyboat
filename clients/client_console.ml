module O = Spyboat_objects 
module L = Spyboat_logic

open Core.Std

module Client = struct
  let get_move b =
    let print_row arr = 
      let f cell =
        let O.Cell(passable, _, _) = cell in
        match passable with
        | true -> print_string "1"
        | false -> print_string "0"
      in
      let _ = Array.iter arr f in
      print_string "\n"
    in

    let O.Board(_, _, cells, _, _) = b in
    let _ = Array.iter cells print_row in
    L.EndTurn
end
