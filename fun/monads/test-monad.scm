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
;; #!r7rs

(define-library
  (test-monad)
  (cond-expand
	(owl-lisp
	  (import (owl defmac)
			  (owl io)
			  (owl base)
			  (scheme base)
			  (mytools r7rs-with-execption)
			  (mytools test)
			  (monads maybe)
			  ))
	(racket
	  (import (except (racket base) exit)
			  (racket control)
			  (scheme process-context)
			  (mytools racketwithexception)
			  (mytools test)
			  (monads maybe)))
	(else
	  (import (scheme base)
			  (scheme write)
			  (mytools r7rs-with-execption)
			  (mytools test)
			  (monads maybe)
			  )))

  (begin
	;; ----------------------------------------------------------------------
	;; test


	(display ";; ----------------------------------------------------------------------\n")
	(display "(define maybe-cdr (map-function-to-maybe cdr))\n")
	(let ((maybe-cdr (map-function-to-maybe cdr null? '()))
		  (object (make-maybe '(1 2))))

	  (test (maybe-cdr object)
			'(2))

	  (test (maybe-cdr (maybe-cdr object))
			'())

	  (test (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object))))
			'())

	  (test (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object)))))
			'())

	  (test (cdr (cdr (cdr (cdr '(1 2)))))
			test-error))
	(let ((maybe-div (map-function-to-maybe 
					   (lambda(object)
						 (/ (car object) (cadr object)))
					   (lambda(object)
						 (cond 
						   ((not (pair? object)) #t)
						   ((null? (cdr object)) #t)
						   ((not (integer? (car object))) #t)
						   ((not (integer? (cadr object))) #t)
						   ((equal? (cadr object) 0) #t)
						   (else #f)))
					   #f)))
	  (test (maybe-div (make-maybe '(10 a))) #f)
	  (test (maybe-div (make-maybe '(10))) #f)
	  (test (maybe-div (make-maybe 'a0)) #f)
	  (test (maybe-div (make-maybe '(a0 2))) #f)
	  (test (maybe-div (make-maybe '(10 2))) 5)
	  (test (maybe-div (make-maybe '(10 0))) #f))
	  (display "\nEnd of tests\n")
		
	))

