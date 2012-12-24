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

let regexp newline = ('\n' | '\r' | "\r\n" | "\n\r")

let rec prop buf = lexer
  | '\\' newline -> prop buf lexbuf

  | ']' -> Buffer.contents buf

  | newline ->
    Buffer.add_char buf '\n';
    prop buf lexbuf

  | '\\' _  ->
    Buffer.add_string buf (utf8_lexeme lexbuf);
    prop buf lexbuf

  | eof -> failwith "Unterminated prop"

  | _ ->
    Buffer.add_string buf (utf8_lexeme lexbuf);
    prop buf lexbuf


let rec token = lexer

(* Début d'une prop *)
  | '[' ->
    PROPCONTENT (prop (Buffer.create 10) lexbuf)

  | (' ' | '\t')+ -> token lexbuf
  | newline -> token lexbuf

(* Ponctuation *)
  | '(' -> LPAR
  | ')' -> RPAR
  | ';' -> SEMI

  | ['A'-'Z']+ -> PROPNAME(utf8_lexeme lexbuf)
  | eof   -> EOF
