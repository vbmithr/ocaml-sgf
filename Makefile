default:
	ocamlbuild -yaccflags --explain -classic-display main.native

top:
	ocamlbuild -no-log -classic-display testing.cma
	ocamlmktop _build/testing.cma -o _build/main.top
	_build/main.top -I _build

tar:
	tar -cvvzf asc.tar.gz *.ml Makefile parser.mly lexer.mll \
	*.ex _tags

clean:
	ocamlbuild -clean
