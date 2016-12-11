#!/bin/sh

dirs="hexdump $(find lib -type d)"
allscheme="gosh foment sagittarius"
libs="lib/tools lib/fileOperations lib/sl-printf lib/tester lib/bbmatch ."
ici=$(dirname $0)

base=${ici}/lib

doIncOptions() {
	flag=''
	case $1 in
		gosh)
			flag="-I "
			;;
		sagittarius)
			flag="-L "
			;;
		foment)
			flag="-I "
			;;
	esac
		
	for d in $libs
	do
		echo "${flag}$d"
	done | tr '\n' ' '
}

for dir in $dirs
do
	for f in $(ls $dir/*-test.scm 2> /dev/null)
	do
		echo "======================================================================"
		echo "$dir -> $f"
		for sch in $allscheme 
		do
			echo "--> $sch $(doIncOptions $sch) $f"
			$sch $(doIncOptions $sch) $f
		done
	done
done
