#!/bin/sh

cat *.scm > tfile
hexdump -C -v tfile | tr -s ' ' > ref.log
gosh -r 7 -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > gosh.log
foment -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > foment.log
sagittarius -r 7 -L . ./hexdump.scm tfile | tr -s ' ' > sagittarius.log

for sch in gosh foment sagittarius
do
	echo "======================================================================"
	echo "$sch"
	diff -EbBw ref.log $sch.log
done
rm tfile

