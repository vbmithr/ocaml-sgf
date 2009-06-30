open Ast
open Printf
open Lexing

let rec print_col ch c =
  List.iter (fun x -> print_gm ch x; Printf.printf "\n\n%!") c

and print_gm ch gm =
  Printf.fprintf ch "(%!";
  (match gm with
     | GT gt  -> List.iter (fun x -> print_gm ch x) gt
     | Seq sq -> print_seq ch sq);
  Printf.fprintf ch ")%!"

and print_seq ch s =
  List.iter (fun x -> print_node ch x) s

and print_node ch n =
  Printf.fprintf ch ";%!";
  List.iter (fun x -> print_prop ch x) n

and print_prop ch {prop_name = pn; prop_value = pv} =
  Printf.fprintf ch "%s%!" pn;
  List.iter (fun x -> Printf.fprintf ch "[%s] %!" x) pv
