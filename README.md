# ocaml-sgf

This is a simple library for parsing the SGF FF[4] file format used to
store game records of board games for two players, and especially the
game of Go. It uses ulex and menhir to do the lexing and
parsing. UTF-8 in SGF files is handled correctly, thanks to ulex.

## Dependencies

* ulex
* menhir

You can install these dependencies with OPAM.

## Building

Just type `make`. It will produce a `main.native` executable,
currently, it just takes an SGF file as an input, parse it, and print
the result in the standard output. The result should be equivalent to
the input, modulo line breaks / spaces.

## How to use it

Look at the `main.ml` to see how it works. This code could be
transformed into a library using OASIS in no time, don’t hesitate to
drop me a message if by chance you would need that.
