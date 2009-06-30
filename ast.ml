type collection = gametree list

and gametree =
    GT  of gametree list
  | Seq of sequence

and sequence = node list

and node = property list

and property = { prop_name:  string;
                 prop_value: string list }

(* and value = *)
(*     UcLetter of char *)
(*   | Digit of int *)
(*   | None *)
(*   | Number of int *)
(*   | Real of float *)
(*   | Double of bool *)
(*   | Color of bool *)
(*   | SimpleText of string *)
(*   | Text of string *)
(*   | Move of char * char *)
(*   | Compose of value * value *)
