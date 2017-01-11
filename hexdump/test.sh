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
export issagittarius=$(which sagittarius)
export isgosh=$(which gosh)
export isfoment=$(which foment)
export ischicken=$(which csc)

if [[ -n $issagittarius ]]
then
    echo 'sagittarius ========================================'
    time sagittarius -r 7 -L . ./hexdump.scm tfile | tr -s ' ' > sagittarius.log
fi

if [[ -n $isgosh ]]
then
    echo 'gosh ========================================'
    time gosh -r 7 -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > gosh.log
fi

if [[ -n $isfoment ]]
then
    echo 'foment ========================================'
    time foment -I ../lib -I . ./hexdump.scm tfile | tr -s ' ' > foment.log
fi

if [[ -n $ischicken ]]
then
    echo 'chicken ========================================'
    ${MAKE} all &> mak.log
    time ./hexdump.exe tfile | tr -s ' ' > chicken.log
fi

echo 'done ========================================'


for sch in sagittarius gosh foment chicken
do
    test=is${sch}
    if [[ -n ${!test} ]]
    then
    	echo "======================================================================"
    	echo "$sch"
    	diff -EbBw ref.log $sch.log > /dev/null || echo "FAILED !!!!"
    fi
done
