## ======================================================================
## Makefile
## ======================================================================

OL = ol
CC = gcc5
OPTIM =
RM = rm -f

SRCS = owl-fact.scm
CSRCS = $(SRCS:%.scm=%.c)
OBJS = $(CSRCS:%.c=%.o)
EXE = fact.exe

all: $(EXE)

$(EXE): $(OBJS)
	$(CC) $(OBJS) -o $@

%.c:%.scm
	$(OL) $(OPTIM) -o $@ $<

%.o:%.c
	$(CC) $(OPTIM) -c -o $@ $<

clean:
	$(RM) fact $(OBJS) $(CSRCS)

.PHONY: all clean
