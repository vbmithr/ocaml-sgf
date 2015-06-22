exception Scanning_error of Lexing.position * string
exception Syntax_error of Lexing.position

let parse fname menhir_parser lexbuf =
  let open Lexing in
  let position = ref
      { pos_fname = fname; pos_lnum = 1; pos_bol = 0; pos_cnum = 0 } in
  let lexer () =
    let ante_position = !position in
    let nlines, token = Lexer.main_scanner 1 lexbuf in
    position := {!position with pos_lnum = !position.pos_lnum + nlines;};
    let post_position = !position
    in (token, ante_position, post_position) in
  let revised_parser =
    MenhirLib.Convert.Simplified.traditional2revised menhir_parser
  in
  try revised_parser lexer with
  | Failure x -> raise (Scanning_error (!position, x))
  | Parser.Error  ->
    Printf.eprintf "Syntax error at %d,%d.\n"
      (!position).pos_lnum (!position).pos_cnum;
    raise (Syntax_error !position)

let sgf_of_string s =
  let lexbuf = Sedlexing.Utf8.from_string s in
  parse "" Parser.collection lexbuf

let sgf_of_channel ic =
  let lexbuf = Sedlexing.Utf8.from_channel ic in
  parse "" Parser.collection lexbuf

let sgf_of_file fn =
  let ic = open_in fn in
  try
    let r = sgf_of_channel ic in close_in ic; r
  with exn ->
    close_in ic; raise exn
