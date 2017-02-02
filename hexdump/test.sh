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
time=/usr/bin/time

if [[ -n $issagittarius ]]
then
    echo 'sagittarius ========================================'
    $time -ao sagittarius-time.log sagittarius -r 7 -L . ./hexdump.scm tfile | tr -s ' ' > sagittarius.log
fi

if [[ -n $isgosh ]]
then
    echo 'gosh ========================================'
    $time -ao gosh-time.log gosh -r 7 -I . ./hexdump.scm tfile | tr -s ' ' > gosh.log
fi

if [[ -n $isfoment ]]
then
    echo 'foment ========================================'
    $time -ao foment-time.log foment -I . ./hexdump.scm tfile | tr -s ' ' > foment.log
fi

if [[ -n $ischicken ]]
then
    echo 'chicken ========================================'
    ${MAKE} all &> mak.log
    $time -ao chicken-time.log ./hexdump.exe tfile | tr -s ' ' > chicken.log
fi

echo 'done ========================================'


for sch in sagittarius gosh foment chicken
do
    test=is${sch}
    if [[ -n ${!test} ]]
    then
    	echo "======================================================================"
    	echo "$sch"
		tail -5 $sch-time.log
    	diff -EbBw ref.log $sch.log > /dev/null || echo "FAILED !!!!"
    fi
done
