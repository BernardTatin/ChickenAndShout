# ======================================================================
# app-in-one.mk
# for ChickenAndShout builds
#
# The MIT License (MIT)
# 
# Copyright (c) 2016 Bernard Tatin
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# ======================================================================

INCS = -I.
R7RS = -X r7rs -R r7rs 
OPT =  -debug-level 0 -verbose $(INCS)
CSC = csc $(R7RS) $(OPT)
LOG = mk.log

RM = rm -f

APP = $(SRC_APP:%.scm=%.exe)
APPINONE = appinone-$(SRC_APP)

all: $(APP)

$(APP): $(APPINONE)
	$(CSC) $< -o $@ 

$(APPINONE): $(SOURCES) $(SRC_APP)
	cat $(SOURCES) $(SRC_APP) > $@


clean:
	rm -f $(APP) $(APPINONE) $(LOG)

test: all
	./$(APP)
	 
.PHONY: all clean test


