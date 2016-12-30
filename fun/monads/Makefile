# ======================================================================
# GNU Makefile for gmake
# for Chicken
# ======================================================================

CSC = csc -X r7rs -R r7rs
CSCOPT =

SRC_LIBS = mytools/r7rs-with-execption.scm mytools/test.scm monads/maybe.scm
LIBS = $(subst /,.,$(SRC_LIBS:%.scm=%.so))
IMPORTS = $(LIBS:%.so=%.import.scm)

SRC_APP = test-monad.scm
APP = $(SRC_APP:%.scm=%.exe)


all: $(APP)

$(APP): $(SRC_APP) $(LIBS)
	$(CSC) $< -o $@ > /dev/null

$(LIBS): $(SRC_LIBS)
	for f in $(SRC_LIBS); do \
		$(CSC) -sJ -o $$(echo $${f%.scm}.so | tr '/' '.') $$f > /dev/null; \
	done

clean:
	@echo "LIBS: $(LIBS)"
	@echo "IMPORTS: $(IMPORTS)"
	rm -f $(APP) $(LIBS) $(IMPORTS)

test: all
	./$(APP)
	 
.PHONY: all clean test

