module O = Spyboat_objects 
module L = Spyboat_logic

open Core.Std

module Client = struct
  let print_board b = 
    let O.Board(width, height, cells, player_units, enemy_units, _) = b in

    let print_height = height * 2 + 1 in
    let print_width = width * 2 + 1 in

    let parr = Array.make_matrix ~dimx:print_height ~dimy:print_width ' ' in

    (* I'll do this idiomatically later *)
    for i = 0 to (print_height - 1) do
      let i_even = (i mod 2) = 0 in
      for j = 0 to (print_width - 1) do 
        let j_even = (j mod 2) = 0 in

        if (i_even && j_even) then parr.(i).(j) <- '+'
        else if (i_even) then parr.(i).(j) <- '-'
        else if (j_even) then parr.(i).(j) <- '|'
      done
    done;

    let mark_row y row = 
      let mark_cell x (O.Cell(passable, uid_opt, cred_opt)) = 
        match uid_opt with
          None -> ()
        | Some(uuid) -> parr.(2*y+1).(2*x+1) <- O.char_of_uuid uuid;

        match (cred_opt) with
          None -> ()
        | Some(_) -> parr.(2*y+1).(2*x+1) <- '$';

        if (not passable) then parr.(2*y+1).(2*x+1) <- 'X'
      in

      Array.iteri ~f:mark_cell row
    in

    Array.iteri ~f:mark_row cells;

    let print_row row = 
      Array.iter ~f:print_char row; print_char '\n'
    in

    Array.iter ~f:print_row parr 

  let get_move b =
    let O.Board(_,_,_,_,_, current_unit) = b in
    let () = print_board b in
    L.EndTurn

end
