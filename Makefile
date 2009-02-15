# -*- Makefile -*-

.PHONY: default opt byte clean

# Config
# ------------------------------------------------ #
OCAMLBUILD         = ocamlbuild
OPTIONS            = -tag debug -quiet
BINARIES           = main
DOCDIR             = main.docdir

# Rules
# ------------------------------------------------ #
default: opt

opt:
	$(OCAMLBUILD) $(OPTIONS) $(BINARIES:%=%.native)

byte:
	$(OCAMLBUILD) $(OPTIONS) $(BINARIES:%=%.byte)

doc:
	$(OCAMLBUILD) $(DOCDIR)/index.html
clean:
	$(OCAMLBUILD) -clean
