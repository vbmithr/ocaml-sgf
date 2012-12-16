type proptype =
  | Empty
  | Number  of int
  | Real    of float
  | Normal | Emph
  | Black | White
  | Text    of string
  | Point   of char * char
  | Move    of char * char
  | Compose of proptype * proptype

type hlproperty = { pname: string; pvalue: proptype list }

let point_of_string str = Point (str.[0], str.[1])
let move_of_string str = Move (str.[0], str.[1])

let hlproperty_of_property { pname; pvalue } = match pname with
  | "AB" -> { pname; pvalue=List.map point_of_string pvalue }
  | "AE" -> { pname; pvalue=List.map point_of_string pvalue }
  | "AW"
  | "PL"
