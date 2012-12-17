type pvalue =
  | Empty
  | Number  of int
  | Real    of float
  | Normal | Emph
  | Black | White
  | Text    of string
  | Point   of char * char
  | Move    of char * char
  | Compose of pvalue * pvalue

type pvalues = One of pvalue | List of pvalue list

type property   = string * pvalues
type node       = property list
type sequence   = node list
type gametree   = Node of sequence * gametree list | Leaf of sequence
type collection = gametree list

let text_of_string str = Text str

let point_of_string str = Point (str.[0], str.[1])

let move_of_string str = Move (str.[0], str.[1])

let number_of_string ?range str =
  let number = int_of_string str in match range with
    | Some (a,b) -> assert (number >= a && number <= b); Number number
    | None -> Number number

let compose_of_string ~f ?s str =
  let sep = Str.regexp_string ":" in
  match Str.bounded_split sep str 2 with
    | [a;b] ->
      (match s with None -> Compose (f a, f b)
        | Some s -> Compose (f a, s b))
    | _ -> failwith "compose_of_string"

let property_of_tuple pname pvalues =
  let pvalue = try List.hd pvalues with Failure "hd" -> "" in
  match pname with
    (* Move *)
    | "B" ->  pname, List (List.map move_of_string pvalues)
    | "KO" -> pname, One Empty
    | "MN" -> pname, One (number_of_string pvalue)
    | "W" ->  pname, List (List.map move_of_string pvalues)

    (* Setup *)
    | "AB" -> pname, List (List.map point_of_string pvalues)
    | "AE" -> pname, List (List.map point_of_string pvalues)
    | "AW"  -> pname, List (List.map point_of_string pvalues)
    | "PL" -> pname,
      (match pvalue with
        | "B" -> One Black
        | "W" -> One White
        | oth -> failwith
          (Printf.sprintf "property_of_tuple: unknown color %s" oth))

    (* Node annotation *)
    | "C" -> pname, One (Text pvalue)

    (* Root *)
    | "AP" -> pname, One (compose_of_string ~f:text_of_string pvalue)
    | "CA" -> pname, One (Text pvalue)
    | "FF" -> pname, One (number_of_string ~range:(1,4) pvalue)
    | "GM" -> pname, One (number_of_string ~range:(1,16) pvalue)
    | "ST" -> pname, One (number_of_string ~range:(0,3) pvalue)
    | "SZ" -> pname,
      (try One (compose_of_string ~f:number_of_string pvalue)
       with Failure _ -> One (number_of_string pvalue))

    (* Game Info *)
    | "RU" -> pname, One (Text pvalue)

    (* Go specific *)
    | "KM" -> pname, One (Real (float_of_string pvalue))

    (* Unknown *)
    | oth -> oth, One (Text pvalue)
