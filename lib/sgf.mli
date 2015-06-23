open Rresult

(** {2 Types} *)

type pvalue =
  | Empty
  | Number of int
  | Real of float
  | Normal
  | Emph
  | Black
  | White
  | Text of string
  | Point of char * char
  | Move of (char * char) option
  | Compose of pvalue * pvalue

type pvalues = One of pvalue | List of pvalue list
type property = string * pvalues
type node = property list
type sequence = node list
type gametree = Node of sequence * gametree list | Leaf of sequence
type collection = gametree list

type err =
  | Lexing_error of Lexing.position * string
  | Parsing_error of Lexing.position

(** {2 Parsing} *)

val sgf_of_string : string -> (collection, err) result
val sgf_of_channel : in_channel -> (collection, err) result
val sgf_of_file : string -> (collection, err) result

(** {2 Printing} *)

val pp_property : Format.formatter -> property -> unit
val pp_node : Format.formatter -> node -> unit
val pp_sequence : Format.formatter -> sequence -> unit
val pp_gametree : Format.formatter -> gametree -> unit
val pp_collection : Format.formatter -> collection -> unit
