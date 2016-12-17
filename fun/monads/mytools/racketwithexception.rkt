#!r7rs

(define-library
  (mytools racketwithexception)
  (export with-exception)
  (import (racket base))
  (begin
    
    (define-syntax with-exception
      (syntax-rules (try lecatch)
        ((with-exception (try <dotry>) (lecatch <docatch>))
         (with-handlers
          ((exn:fail?
			(lambda(exc)
            ;; (display "[SYS ERROR] --> ")
            ;; (display exc)
            ;; (display "\n")
            <docatch>)))
          (begin
            <dotry>)))))
    ))
