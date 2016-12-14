;; ======================================================================
;; test-monad.scm
;;		ol test-monad.scm
;;		foment -I . test-monad.scm
;;		gosh -r 7 -I . ./test-monad.scm
;;		sagittarius -r 7 -L . ./test-monad.scm
;; NB : for sagittarius :
;;		sudo ldconfig -m /usr/perso/lib/sagittarius /usr/perso/lib
;; ======================================================================
(define-library
  (test-monad)
  (cond-expand
	(owl-lisp
	  (import (owl defmac)
			  (owl io)
			  (scheme base)
			  (monads maybe)))
	(else
	  (import (scheme base)
			  (scheme write)
			  (monads maybe))))
  (begin
	;; ----------------------------------------------------------------------
	;; test

	(display ";; ----------------------------------------------------------------------\n")
	(display "(define maybe-cdr (map-function-to-maybe cdr))\n")
	(let ((maybe-cdr (map-function-to-maybe cdr))
		  (object (make-maybe '(1 2))))

	  (display "(maybe-cdr (make-maybe '(1 2))) \n\texpect -> (2) \n\tget -> ")
	  (display (maybe-cdr object))
	  (display "\n")

	  (display "(maybe-cdr (maybe-cdr (make-maybe '(1 2)))) \n\texpect -> () \n\tget -> ")
	  (display (maybe-cdr (maybe-cdr object)))
	  (display "\n")

	  (display "(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (make-maybe '(1 2)))))) \n\texpect -> Error \n\tget -> ")
	  (display (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object)))))
	  (display "\n")

	  (display "(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (make-maybe '(1 2))))))) \n\texpect -> Error \n\tget -> ")
	  (display (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object))))))
	  (display "\n")
	  (display "\n")
	  (display "\n")

	  (display "last compute is same as :\n")
	  (display "(cdr (cdr (cdr (cdr '(1 2))))) \n\tget -> ")
	  (display (cdr (cdr (cdr (cdr '(1 2))))))
	  (display "\n"))
	))
