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
	(define-syntax test
	  (syntax-rules ()
					((test message expression expected)
					 (begin
					   (let ((e (with-exception return
												(try
												  (lambda()
													expression))
												(lecatch
												  (lambda(e)
													(return test-error))))))
						 (begin
						   (display message)
						   (display "\n\texpected -> ") (display expected)
						   (display "\n\tget      -> ") 
						   (display e) (display "\n")
						   (if (equal? e expected)
							 (display test-OK)
							 (display test-FAIL))))))))
	))
