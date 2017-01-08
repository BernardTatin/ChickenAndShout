#!r7rs

(define-library
  (mytools racketwithexception)
  (export with-exception)
  (import (racket base))
  (begin
    
    (define-syntax with-exception
	  (syntax-rules (try lecatch)
					((with-exception <return> (try <dotry>) (lecatch <docatch>))
					 (let ((<return> (lambda(a) a)))
					   (with-handlers
						 ((exn:fail?
							<docatch>))
						 (let ((f <dotry>))
						   (f)))))))
    ))
