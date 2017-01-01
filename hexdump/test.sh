#!/bin/bash

[[ -f tfile ]] || (cat **/*.scm > tfile; rm ref.log)
echo 'hexdump ========================================'
[[ -f ref.log ]] || hexdump -C -v tfile | tr -s ' ' > ref.log

echo 'sagittarius ========================================'
time sagittarius -r 7 -L . ./hexdump.scm tfile | tr -s ' ' > sagittarius.log

echo 'gosh ========================================'
time gosh -r 7 -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > gosh.log

echo 'foment ========================================'
time foment -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > foment.log

echo 'chicken ========================================'
gmake all &> mak.log
time ./hexdump.exe tfile | tr -s ' ' > chicken.log

echo 'done ========================================'


for sch in sagittarius gosh foment chicken
do
	echo "======================================================================"
	echo "$sch"
	diff -EbBw ref.log $sch.log > /dev/null || echo "FAILED !!!!"
done
