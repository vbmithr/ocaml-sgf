(** Exceptions *)

exception Scanning_error of Lexing.position * string
exception Syntax_error of Lexing.position

(** Parsing functions *)

val sgf_of_string : string -> Ast.collection
val sgf_of_channel : in_channel -> Ast.collection
val sgf_of_file : string -> Ast.collection
