open Ast
open Printf
open Lexing

let print_prop ch {prop_name = pn; prop_value = pv} =
  Printf.fprintf ch "%s" pn;
  List.iter (fun x -> Printf.fprintf ch "[%s]" x) pv;
  if not ((String.length pn) = 1 && (pn.[0] = 'B' || pn.[0] = 'W'))
  then Printf.fprintf ch "\n"

let print_node ch n =
  Printf.fprintf ch ";";
  List.iter (fun x -> print_prop ch x) n

let print_seq ch s =
  List.iter (fun x -> print_node ch x) s

let rec print_gm ch gm =
  Printf.fprintf ch "(";
  (match gm with
     | Node (seq, gts)  -> print_seq ch seq; List.iter (fun x -> print_gm ch x) gts
     | Leaf seq -> print_seq ch seq);
  Printf.fprintf ch ")"

let print_col ch c =
  List.iter (fun x -> print_gm ch x; Printf.printf "\n") c
