
(define-library
  (mytools r7rs-with-execption)
  (export with-exception abort)
  (import (scheme base)
		  (scheme write))
  (begin
    (define-syntax with-exception
      (syntax-rules (try lecatch)
        ((with-exception (try <dotry>) (lecatch <docatch>))
         (guard
          (exc
           (else
            (begin
              ;; (display "[SYS ERROR] --> ")
              ;; (display exc)
              ;; (display "\n")
              <docatch>
              )
            ))
          (begin
            <dotry>)))))
	(define abort
	  (lambda(v)
		v))
    ))
