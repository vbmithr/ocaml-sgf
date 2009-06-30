open Printf
open Lexing

(**********************************************************************)
(* Gestion des erreurs d'analyse lexicale                             *)

type lexing_exception =
  | InvalidChar of Lexing.position * char
  | UnterminatedProp of Lexing.position

exception LexingError of lexing_exception

let raise_lexing_exception e = raise (LexingError e)

let pos_char pos =
  pos.pos_cnum - pos.pos_bol
let pos_line pos =
  pos.pos_lnum

let print_pos ch pos =
  fprintf ch "ligne %d, caractère %d" (pos_line pos) (pos_char pos)

let print_lexing_error ch = function
  | InvalidChar (p, c) ->
      fprintf ch "Caractère '%c' non reconnu, %a\n" c print_pos p
  | UnterminatedProp p ->
      fprintf ch "Propriété non terminée (commencée %a)\n" print_pos p

(**********************************************************************)
(* Gestion des erreurs d'analyse syntaxique                           *)

let print_parsing_error ch lexbuf  =
  let pstart = lexeme_start_p lexbuf
  and pend =  lexeme_end_p lexbuf in
  if pstart = pend then
    fprintf ch "Erreur de syntaxe au lexème %a\n" print_pos pstart
  else
    if pstart.pos_lnum = pend.pos_lnum then
      fprintf ch "Erreur de syntaxe au lexème ligne %d, caractères %d à %d\n"
        (pos_line pstart) (pos_char pstart) (pos_char pend)
    else
      fprintf ch "Erreur de syntaxe au lexème allant de la %a à la %a\n"
        print_pos pstart print_pos pend
