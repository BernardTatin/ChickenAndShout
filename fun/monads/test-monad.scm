;; ======================================================================
;; test-monad.scm
;;		ol test-monad.scm
;;		foment -I . test-monad.scm
;;		gosh -r 7 -I . ./test-monad.scm
;;		sagittarius -r 7 -L . ./test-monad.scm
;; NB : for sagittarius :
;;		sudo ldconfig -m /usr/perso/lib/sagittarius /usr/perso/lib
;; NB : for racket :
;;          mkdir -p /home/bernard/.racket/6.6/collects
;;          ln -s monads /home/bernard/.racket/6.6/collects/monads
;;          cd /home/bernard/.racket/6.6/collects/monads
;;          ln -s maybe.scm maybe.rkt
;; ======================================================================
#!r7rs

(define-library
  (test-monad)
  (cond-expand
	(owl-lisp
	  (import (owl defmac)
			  (owl io)
			  (scheme base)
			  (mytools r7rs-with-execption)
			  (monads maybe)
			  ))
	(racket
	  (import (except (racket base) exit)
			  (racket control)
			  (scheme process-context)
			  (mytools racketwithexception)
			  (monads maybe)))
	(else
	  (import (scheme base)
			  (scheme write)
			  (mytools r7rs-with-execption)
			  (monads maybe)
			  )))

  (begin
	;; ----------------------------------------------------------------------
	;; test

	(define test-error '("Error"))
	(define test-OK "---- >>> OK\n")
	(define test-FAIL "---- >>> FAILURE\n")
	(define-syntax test
	  (syntax-rules ()
					((test message expression expected)
					 (begin
					   (display message)
					   (display "\n\texpected -> ") (display expected)
					   (display "\n\tget      -> ") 
					   (let ((e (with-exception
								  (try
									expression)
								  (lecatch
									(begin
									  test-error)))))
						 (display e) (display "\n")
						 (if (equal? e expected)
						   (display test-OK)
						   (display test-FAIL)))))))

	(display ";; ----------------------------------------------------------------------\n")
	(display "(define maybe-cdr (map-function-to-maybe cdr))\n")
	(let ((maybe-cdr (map-function-to-maybe cdr))
		  (object (make-maybe '(1 2))))

	  (test "(maybe-cdr (make-maybe '(1 2)))"
			(maybe-cdr object)
			'(2))

	  (test "(maybe-cdr (maybe-cdr (make-maybe '(1 2))))"
			(maybe-cdr (maybe-cdr object))
			'())

	  (test "(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (make-maybe '(1 2))))))"
			(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object))))
			'())

	  (test "(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (make-maybe '(1 2)))))))"
			(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object)))))
			'())

	  (test "(cdr (cdr (cdr (cdr '(1 2)))))"
			(cdr (cdr (cdr (cdr '(1 2)))))
			test-error)
	  (display "\nEnd of tests\n")
	  )
	))
