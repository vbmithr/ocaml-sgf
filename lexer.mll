{
  (* code recopie en debut de fichier *)
  exception Eof
  exception UnterminatedString
  exception InvalidChar
}

let digit     = ['0'-'9']
let ucletter  = ['A'-'Z']

let propident = ucletter+

let number = ('+'|'-')? digit+
let real   = number ('.' digit+ )?

(* let double = '1' | '2' *)
(* let color  = 'B' | 'W' *)

(* à compléter (UTF-8) *)
let blank = [' ' '\t']

let newline = ('\n' | '\r' | "\r\n" "\n\r")

(* let property = ucletter | digit | *)

rule token = parse
  | '['
      { let string_start = lexeme_start_p lexbuf in
        let s = (string string_start (Buffer.create 10) lexbuf) in
          lexbuf.lex_start_p <- string_start;
          STRING s }
  | '('   { LPAR }
  | ')'   { RPAR }
  | ';'   { SEMI }
  | blank { token lexbuf }
  | propident as s { PROPIDENT(s) }

  | _ as c      { raise InvalidChar }
  | eof         { raise Eof }

(* start est la position de depart de la chaine, buf le buffer contenant
   la partie deja lue de la chaine *)
and string start buf = parse
  | '\\' newline
    { string start buf lexbuf }
  | ']' (* Caractère de fin de chaine. *)
    { Buffer.contents buf }
  | eof { raise UnterminatedString }
  | '\\' (_ as c) | _ as c
    { Buffer.add_char buf c;
      string start buf lexbuf }

{
  (* code recopie en fin de fichier *)
  (* boucle d'appel de lexeur pour chaque lexeme *)
  let lexbuf = Lexing.from_channel stdin in
    try
      token lexbuf
    with Eof -> ()
}
