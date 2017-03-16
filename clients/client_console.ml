module O = Spyboat_objects 
module B = Board_logic
module G = Game_logic

module Term = ANSITerminal

open Core.Std

module Client = struct
  let print_board boat =
    let module B = O.BoardState in
    let module C = O.Cell in

    let {B.width; B.height; B.cells; B.player_units; B.enemy_units} = boat in

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
      let mark_cell x {C.passable; C.uid_opt; C.credit_opt} = 
        if (not passable) then parr.(2*y+1).(2*x+1) <- 'X'; 

        match uid_opt with
          None -> ()
        | Some(uuid) -> parr.(2*y+1).(2*x+1) <- O.char_of_uuid uuid;

          match (credit_opt) with
            None -> ()
          | Some(_) -> parr.(2*y+1).(2*x+1) <- '$';
      in

      Array.iteri ~f:mark_cell row
    in

    Array.iteri ~f:mark_row cells;

    let print_row row = 
      Array.iter ~f:print_char row; print_char '\n'
    in

    Array.iter ~f:print_row parr 

  let print_unit boat =
    let module U = O.UnitState in
    let module T = O.UnitTemplate in

    let {U.template; U.uid; U.move_rate; U.max_size; U.head = (h_x, h_y)} = boat in
    let {T.name; T.descr; T.affects} = template in

    Printf.printf "%s id: %c pos: (%d, %d): Max Size %d, move rate %d\n%s\n"
      name (O.char_of_uuid uid) h_x h_y max_size move_rate descr;

    let affect_string = (String.concat ~sep:"\n\t" (List.map ~f:O.string_of_affect affects)) in
    Printf.printf "Affects:\n\t%s\n" affect_string

  let get_move b boat =
    let module T = O.UnitTemplate in 
    let module U = O.UnitState in

    let () = Term.erase Term.Screen; Term.move_cursor 0 (-100) in
    let () = print_board b in
    let () = print_unit boat in
    let () = print_string "move> " in

    let {U.template = {O.UnitTemplate.affects}; U.head = (h_x, h_y)} = boat in
    let c = String.get (read_line ()) 0 in

    match c with 
    | 'w' -> G.BoardAction(B.Step(B.UP))
    | 's' -> G.BoardAction(B.Step(B.DOWN))
    | 'a' -> G.BoardAction(B.Step(B.LEFT))
    | 'd' -> G.BoardAction(B.Step(B.RIGHT))

    (* TODO figure out a resonable abstraction for undoing *)
    | 'u' -> G.BoardAction(B.Undo(B.HeadCut(None)))
    | 'a' ->
      begin
        let input = read_line () in
        Scanf.sscanf input "%d %d %d" (fun aid d_x d_y ->
            let affect = List.nth_exn affects aid in
            let target = h_x + d_x, h_y + d_y in
            G.BoardAction(B.Attack(affect, target)))
      end
    | _ -> G.BoardAction(B.Step(B.DOWN))

end
