
(define-library
  (mytools r7rs-with-execption)
  (export with-exception abort)
  (cond-expand
	(owl-lisp
	  (import (owl core)
			  (owl defmac)
			  (owl base)
			  (scheme base)
			  (scheme write)))
	(else
	  (import
		(scheme base)
		(scheme write))))
  (begin

	(cond-expand
	  (foment
		(define-syntax with-exception
		  (syntax-rules (try lecatch)
						((with-exception <return> (try <dotry>) (lecatch <docatch>))
						 (call-with-current-continuation
						   (lambda (<return>)
							 (with-exception-handler 
							   <docatch>
							   <dotry>)))))))
	  (else
		(define-syntax with-exception
		  (syntax-rules (try lecatch)
						((with-exception  <return> (try <dotry>) (lecatch <docatch>))
						 (let ((<return> (lambda(a) a)))
						   (guard
							 (exc
							   (else
								 (let ((f <docatch>))
								   ;; (display "[SYS ERROR] --> ")
								   ;; (display exc)
								   ;; (display "\n")
								   (f exc))))
							 (let ((g <dotry>))
							   (g)))))))))

	  (define abort
		(lambda(v)
		  v))

	  ))
