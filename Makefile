all:
	ocamlbuild -use-ocamlfind -yaccflags --explain main.native

clean:
	ocamlbuild -clean
