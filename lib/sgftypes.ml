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
