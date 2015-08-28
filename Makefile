all: build

EXAMPLES_FLAG=--enable-examples

J=6

resetup: clean
	oasis setup-clean && \
	  oasis setup

setup.data: setup.ml
	ocaml setup.ml -configure \
		$(EXAMPLES_FLAG) \

build: setup.data setup.ml
	ocaml setup.ml -build -j $(J)

clean:
	ocamlbuild -clean
	rm -f setup.data setup.log
