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

type pvalue =
  | Empty
  | Number  of int
  | Real    of float
  | Normal | Emph
  | Black  | White
  | Text    of string
  | Point   of char * char
  | Move    of char * char
  | Compose of pvalue * pvalue

type pvalues    = One of pvalue | List of pvalue list
type property   = string * pvalues
type node       = property list
type sequence   = node list
type gametree   = Node of sequence * gametree list | Leaf of sequence
type collection = gametree list

let text_of_string str = Text str

let point_of_string str = Point (str.[0], str.[1])

let move_of_string str = Move (str.[0], str.[1])

let double_of_string = function
  | "1" -> Normal
  | "2" -> Emph
  | _   -> failwith "double_of_string"

let color_of_string = function
  | "B" | "b" -> Black
  | "W" | "w" -> White
  | _   -> failwith "color_of_string"

let number_of_string ?range str =
  let number = int_of_string str in match range with
    | Some (a,b) -> assert (number >= a && number <= b); Number number
    | None -> Number number

let real_of_string str = Real (float_of_string str)

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
    | "B" | "W" -> pname, List (List.map move_of_string pvalues)
    | "KO" -> pname, One Empty
    | "MN" -> pname, One (number_of_string pvalue)

    (* Setup *)
    | "AB" | "AE" | "AW" -> pname, List (List.map point_of_string pvalues)
    | "PL" -> pname, One (color_of_string pvalue)

    (* Node annotation *)
    | "C" | "N" -> pname, One (Text pvalue)
    | "DM" | "GB" | "GW" | "HO" | "UC" -> pname, One (double_of_string pvalue)
    | "V"  -> pname, One (real_of_string pvalue)

    (* Move annotation *)
    | "BM" | "TE" -> pname, One (double_of_string pvalue)
    | "DO" | "IT" -> pname, One Empty

    (* Markup *)
    | "AR" | "LN" -> pname, List (List.map (compose_of_string ~f:point_of_string) pvalues)
    | "CR" | "DD" -> pname, List (List.map point_of_string pvalues)
    | "LB" -> pname, List (List.map (compose_of_string ~f:point_of_string ~s:text_of_string) pvalues)
    | "MA" | "SL" | "SQ" | "TR" -> pname, List (List.map point_of_string pvalues)

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
    | "AN" | "BR" | "BT" | "CP" | "DT" | "EV" | "GN" | "GC" | "ON"
    | "OT" | "PB" | "PC" | "PW" | "RE" | "RO" | "RU" | "SO" | "US"
    | "WR" | "WT" -> pname, One (Text pvalue)
    | "TM" -> pname, One (real_of_string pvalue)

    (* Timing *)
    | "BL" | "WL" -> pname, One (real_of_string pvalue)
    | "OB" | "OW" -> pname, One (number_of_string pvalue)

    (* Go specific *)
    | "HA" -> pname, One (number_of_string pvalue)
    | "KM" -> pname, One (real_of_string pvalue)
    | "TB" | "TW" -> pname, List (List.map point_of_string pvalues)

    (* Misc *)
    | "FG" -> pname, (match pvalues with [] -> One Empty | _ ->
      List (List.map (compose_of_string ~f:point_of_string ~s:text_of_string) pvalues))
    | "PM" -> pname, One (number_of_string pvalue)
    | "VW" -> pname, List (List.map point_of_string pvalues)

    (* Unknown *)
    | oth -> oth, One (Text pvalue)
