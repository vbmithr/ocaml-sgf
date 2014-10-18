(*
 * Copyright (c) 2012 Vincent Bernardoff <vb@luminar.eu.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

exception Scanning_error of Lexing.position * string
exception Syntax_error of Lexing.position

let parse fname menhir_parser lexbuf =
  let open Lexing in
  let position = ref
    { pos_fname = fname; pos_lnum = 1; pos_bol = 0; pos_cnum = 0 } in
  let lexer () =
    let ante_position = !position in
    let nlines, token = Lexer.main_scanner 1 lexbuf in
    let () = position := {!position with pos_lnum = !position.pos_lnum + nlines;} in
    let post_position = !position
    in (token, ante_position, post_position) in
  let revised_parser = MenhirLib.Convert.Simplified.traditional2revised menhir_parser
  in try
       revised_parser lexer
    with
      | Lexer.Error x -> raise (Scanning_error (!position, x))
      | Parser.Error  ->
        Printf.eprintf "Syntax error at %d,%d.\n"
          (!position).pos_lnum (!position).pos_cnum;
        raise (Syntax_error !position)

let file = ref ""
let args = []
let usage =
  Printf.sprintf "Usage: %s [filename]\nOptions are:" Sys.argv.(0)

let () =
  Arg.parse args (fun s -> file := s) usage;
  let ch = if !file = "" then stdin else open_in !file in
  let lexbuf = Ulexing.from_utf8_channel ch in
  let c = parse !file Parser.collection lexbuf in
  Print.print_col stdout c
