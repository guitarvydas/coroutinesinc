ODIN_FLAGS ?= -debug -o:none

all: coroutines

coroutines: *.odin */*.odin
	rm -f coroutines
	odin run . $(ODIN_FLAGS)

