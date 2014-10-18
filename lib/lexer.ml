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

open Ulexing
open Parser

exception Error of string

let regexp newline = ('\n' | '\r' | "\r\n" | "\n\r")
let regexp tab = ['\t''\x0b']
let regexp wsp = [' ''\t']

let rec prop_scanner nlines buf = lexer
  (* White spaces other than linebreaks are converted to space
     (e.g. no tab, vertical tab, ..). *)
  | tab -> Buffer.add_char buf ' '; prop_scanner nlines buf lexbuf

  (* Soft line break: linebreaks preceded by a \ (soft linebreaks
     are converted to , i.e. they are removed) *)
  | '\\' newline -> prop_scanner (succ nlines) buf lexbuf

  | ']' -> nlines, Buffer.contents buf

  | newline ->
    Buffer.add_string buf (utf8_lexeme lexbuf);
    prop_scanner (succ nlines) buf lexbuf

  | '\\' [^'\t''\x0b']  ->
    Buffer.add_string buf (utf8_lexeme lexbuf);
    prop_scanner nlines buf lexbuf

  | '\\' tab ->
    Buffer.add_char buf ' ';
    prop_scanner nlines buf lexbuf

  | eof -> raise (Error "Unterminated prop")

  | _ ->
    Buffer.add_string buf (utf8_lexeme lexbuf);
    prop_scanner nlines buf lexbuf

let rec main_scanner nlines = lexer

  (* Début d'une prop *)
  | '[' ->
    let nlines, content = prop_scanner nlines (Buffer.create 10) lexbuf in
    nlines, PROPCONTENT (content)

  | wsp+ -> main_scanner nlines lexbuf
  | newline -> main_scanner (succ nlines) lexbuf

  | '(' -> nlines, LPAR
  | ')' -> nlines, RPAR
  | ';' -> nlines, SEMI

  | ['A'-'Z']+ -> nlines, PROPNAME(utf8_lexeme lexbuf)
  | eof   -> nlines, EOF
