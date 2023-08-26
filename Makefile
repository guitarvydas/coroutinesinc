ODIN_FLAGS ?= -debug -o:none

all: coroutines

coroutines: *.odin */*.odin
	odin run . $(ODIN_FLAGS)

