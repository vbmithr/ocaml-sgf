open Print
open Errors

let file = ref ""
let args = []
let usage = "Usage: ./main.native <options> [fichier] (stdin par default)"

let () =
  Arg.parse args (fun s -> file := s) usage;
  let ch = if !file = "" then stdin else open_in !file in
  let lexbuf = Lexing.from_channel ch in

    try
      let c = Parser.collection Lexer.token lexbuf in
	print_col stdout c
    with
      | LexingError e -> print_lexing_error stderr e
      | Parser.Error  -> print_parsing_error stderr lexbuf
