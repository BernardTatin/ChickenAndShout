# ======================================================================
# GNU Makefile for gmake
# for Chicken
# ======================================================================

CSC = csc -X r7rs -R r7rs
CSCOPT =

SOURCES = mytools/r7rs-with-execption.scm mytools/test.scm monads/maybe.scm
LIBS = $(subst /,.,$(SOURCES:%.scm=%.so))
IMPORTS = $(LIBS:%.so=%.import.scm)

SRC_APP = test-monad.scm
APP = $(SRC_APP:%.scm=%.exe)

all: $(APP)

$(APP): $(SRC_APP) $(LIBS)
	$(CSC) $< -o $@

$(LIBS): $(SOURCES)
	for f in $(SOURCES); do \
		$(CSC) -sJ -o $$(echo $${f%.scm}.so | tr '/' '.') $$f; \
	done

clean:
	@echo "LIBS: $(LIBS)"
	@echo "IMPORTS: $(IMPORTS)"
	rm -f $(APP) $(LIBS) $(IMPORTS)

.PHONY: all clean

