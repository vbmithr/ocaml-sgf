# ocaml-sgf

This is a simple library for parsing the SGF FF[4] file format used to
store game records of board games for two players, and especially the
game of Go. It is implemented with standard OCaml lexing/parsing
tools, ocamllex and menhir.

## Dependencies

* menhir

## Building

Just type `make`. It will produce a `main.native` executable,
currently, it just takes an SGF file as an input, parse it, and print
the result in the standard output. The result should be equivalent to
the input, modulo line breaks / spaces.

## How to use it

Look at the `main.ml` to see how it works. This code could be
transformed into a library using OASIS in no time, don’t hesitate to
drop me a message if by chance you would need that.
