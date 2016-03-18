# ======================================================================
# app.mk
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

CSC = csc $(EXTENSIONS) -c -debug-level 0 -verbose  -I.
CSLD = csc

RM = rm -f


OBJS = $(patsubst %.scm,%.o,$(notdir $(SOURCES)))
CSRCS = $(patsubst %.scm,%.c,$(notdir $(SOURCES)))


all: $(APP)

$(APP): $(OBJS) 
	$(CSLD) $(OBJS) -o $@

clean: 
	$(RM) $(OBJS) $(APP) $(CSRCS)

%.o: %.scm
	$(CSC) $<


.PHONY: all clean


