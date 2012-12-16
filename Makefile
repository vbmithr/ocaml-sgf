all:
	ocamlbuild -yaccflags --explain main.native

clean:
	ocamlbuild -clean
