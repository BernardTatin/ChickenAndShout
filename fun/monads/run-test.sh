#!/bin/sh

scriptname=$(basename $0)

mainscm=test-monad.scm
libs="monads/maybe.scm"

dohelp () {
	cat << DOHELP
${scriptname} [-h|--help] : this text
${scriptname} --foment|--ol|--gosh|--sagittarius|--racket :
		run tests with the named system
${scriptname} -a|--all : run tests for all systems		
DOHELP
	exit 0
}

files_to_racket () {
	while [ $# -ne 0 ]
	do
		sed -I .bak 's/^[ \t]*;*[ \t]*#!r7rs/#!r7rs/' $1
		shift
	done
}

files_to_r7rs () {
	while [ $# -ne 0 ]
	do
		sed -I .bak 's/^[ \t]*#!r7rs/;; #!r7rs/' $1
		shift
	done
}

execute () {
	local scheme=$1
	local mainscm=$2

	case ${scheme} in
		--ol)
			ol ${mainscm}
			;;
		--foment)
			foment -I . ${mainscm}
			;;
		--gosh)
			gosh -r 7 -I . ${mainscm}
			;;
		--sagittarius)
			sagittarius -r 7 -L . ${mainscm}
			;;
	esac
}

dotest () {
	local scheme=$1
	echo ";; ----------------------------------------------------------------------"
	echo "with ${scheme##*-}"
	case ${scheme} in
		--racket)
			files_to_racket ${mainscm} ${libs}
			racket ${mainscm}
			;;
		--foment|--ol|--gosh|--sagittarius)
			files_to_r7rs ${mainscm} ${libs}
			execute ${scheme} ${mainscm}
			;;
		*)
			echo "ERROR : ${scheme} is unknow"
			exit 1
			;;
	esac
}

doall () {
	for scheme in --foment --ol --gosh --sagittarius --racket
	do
		dotest ${scheme}
	done
}
[ $# -eq 0 ] && dohelp
case $1 in
	-h|--help)
		dohelp
		;;
	-a|--all)
		doall
		;;
	--foment|--ol|--gosh|--sagittarius|--racket)
		dotest $1
		;;
	*)
		echo "ERROR : $1, unknown parameter"
		exit 1
		;;
esac
