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

%.o:%.c
	$(CC) $(OPTIM) -c -o $@ $<

%.c:%.scm
	$(OL) $(OPTIM) -o $@ $<

clean:
	$(RM) $(EXE) $(OBJS) $(CSRCS)

.PHONY: all clean
