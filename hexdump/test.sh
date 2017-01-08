#!/bin/bash

OS=$(uname)
case ${OS} in
	FreeBSD)
		MAKE=gmake
		;;
	*)
		MAKE=make
		;;
esac

echo 'clean ========================================'
rm -fv sagittarius.log gosh.log foment.log chicken.log
rm -fv appinone-hexdump.scm hexdump.exe

echo 'init ========================================'
[[ -f tfile ]] || (cat **/*.scm > tfile; rm ref.log)
[[ -f ref.log ]] || hexdump -C -v tfile | tr -s ' ' > ref.log

echo 'sagittarius ========================================'
time sagittarius -r 7 -L . ./hexdump.scm tfile | tr -s ' ' > sagittarius.log

echo 'gosh ========================================'
time gosh -r 7 -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > gosh.log

echo 'foment ========================================'
time foment -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > foment.log

echo 'chicken ========================================'
${MAKE} all &> mak.log
time ./hexdump.exe tfile | tr -s ' ' > chicken.log

echo 'done ========================================'


for sch in sagittarius gosh foment chicken
do
	echo "======================================================================"
	echo "$sch"
	diff -EbBw ref.log $sch.log > /dev/null || echo "FAILED !!!!"
done
