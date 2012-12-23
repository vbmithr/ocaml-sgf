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

{
  open Parser
  open Lexing
  open Errors
}

let blank = (' ' | '\t')
let newline = ('\n' | '\r' | "\r\n" | "\n\r")

let alpha = ['a'-'z''A'-'Z''0'-'9''_']*
let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']

rule token = parse

(* Début d'une prop *)
  | '['
      { let prop_start = lexeme_start_p lexbuf in
        let s = (prop prop_start (Buffer.create 10) lexbuf) in
          lexbuf.lex_start_p <- prop_start;
          PROPCONTENT s }


  | blank+     { token lexbuf }
  | newline    { new_line lexbuf; token lexbuf }

(* Ponctuation *)
  | '(' { LPAR }
  | ')' { RPAR }
  | ";" { SEMI }

  | upper+ as name { PROPNAME(name) }
  | eof            { EOF }

  (* Caractère inconnu *)
  | _ as c          { raise_lexing_exception
			(InvalidChar (lexeme_start_p lexbuf, c)) }

(* start est la position de depart de la chaine, buf le buffer contenant
   la partie deja lue de la chaine *)
and prop start buf = parse
  | '\\' newline
      { prop start buf lexbuf }
  | ']'
      { Buffer.contents buf }
  | newline
      { new_line lexbuf;
        Buffer.add_char buf '\n';
        prop start buf lexbuf }
  | '\\' (_ as c)
      { Buffer.add_char buf c;
        prop start buf lexbuf }
  | eof
      { raise_lexing_exception (UnterminatedProp start) }

  | _ as c
      { Buffer.add_char buf c;
        prop start buf lexbuf }
