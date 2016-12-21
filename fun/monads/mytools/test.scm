;; #!r7rs

(define-library
  (mytools test)
  (export test test-OK test-FAIL test-error)
  (cond-expand
	(owl-lisp
	  (import (owl core)
			  (owl defmac)
			  (owl base)
			  (scheme base) (scheme write)
			  (mytools r7rs-with-execption)))
	(racket
	  (import (racket base)
		(mytools racketwithexception)))
	(else
	  (import
		(scheme base) (scheme write)
		(mytools r7rs-with-execption))))

  (begin
	(define test-OK "---- >>> OK\n")
	(define test-FAIL "---- >>> FAILURE\n")

	(define test-error '("Error"))

	(define (ldisplay . l)
	  (for-each display l))

	(define-syntax test
	  (syntax-rules ()
					((test expression expected)
					 (let ((e (with-exception return
											  (try
												(lambda()
												  expression))
											  (lecatch
												(lambda(e)
												  (return test-error))))))
						 (ldisplay 'expression
								   "\n\texpected -> " 
								   expected
								   "\n\tget      -> "
								   e "\n"
								   (if (equal? e expected)
									 test-OK
									 test-FAIL))))))
	))
