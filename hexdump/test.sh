#!/bin/sh

cat *.scm > tfile
echo 'hexdump ========================================'
# hexdump -C -v tfile | tr -s ' ' > ref.log
hexdump -C -v tfile  > ref.log
echo 'gosh ========================================'
# gosh -r 7 -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > gosh.log
gosh -r 7 -I ../lib -I . ./hexdump.scm tfile > gosh.log
echo 'foment ========================================'
# foment -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > foment.log
foment -I ../lib -I . ./hexdump.scm tfile > foment.log
echo 'sagittarius ========================================'
# sagittarius -r 7 -L . ./hexdump.scm tfile | tr -s ' ' > sagittarius.log
sagittarius -r 7 -L . ./hexdump.scm tfile > sagittarius.log
echo 'done ========================================'


for sch in gosh foment sagittarius
do
	echo "======================================================================"
	echo "$sch"
	diff -EbBw ref.log $sch.log > /dev/null || echo "FAILED !!!!"
done
# rm tfile

