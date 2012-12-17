open Ast
open Printf
open Lexing

let rec string_of_pvalue = function
  | Empty -> ""
  | Number n -> Printf.sprintf "%d" n
  | Real r  -> Printf.sprintf "%.2f" r
  | Normal -> "1" | Emph -> "2"
  | Black -> "B" | White -> "W"
  | Text str -> Printf.sprintf "%s" str
  | Point (a,b) -> Printf.sprintf "%c%c" a b
  | Move (a,b) -> Printf.sprintf "%c%c" a b
  | Compose (a,b) -> string_of_pvalue a ^ ":" ^ string_of_pvalue b

let print_prop ch (pname, pvalues) =
  Printf.fprintf ch "%s" pname;
  (match pvalues with
    | One pvalue -> Printf.fprintf ch "[%s]" (string_of_pvalue pvalue)
    | List pvalues -> List.iter
      (fun pv -> Printf.fprintf ch "[%s]" (string_of_pvalue pv)) pvalues);
  (* if not ((String.length pname) = 1 && (pname.[0] = 'B' || pname.[0] = 'W')) *)
  (* then Printf.fprintf ch "\n" *)
    Printf.fprintf ch "\n"

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
