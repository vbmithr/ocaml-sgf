{
  open Parser
  open Lexing
  open Errors

  let newline lexbuf =
    lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with
                             pos_lnum = lexbuf.lex_curr_p.pos_lnum + 1;
                             pos_bol =  lexbuf.lex_curr_p.pos_cnum;
                         }
}

let blank = (' ' | '\t')
let newline = ('\n' | '\r' | "\r\n" "\n\r")

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
  | newline    { newline lexbuf; token lexbuf }

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
      { newline lexbuf;
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
