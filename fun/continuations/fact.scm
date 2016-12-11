;; ======================================================================
;; fact.scm
;; une factorielle avec continuation
;; owl-lisp:
;; ol -o fact.c fact.scm&& gcc -o fact fact.c && ./fact 5
;; ======================================================================


(define-library 
  (fact)
  (export k-fact show-facts)
  ;; follow this import order !!!
  (import (owl defmac) (owl io) (scheme base) (owl-tools))
  (begin
	(define k-fact 
	  (lambda(value0 N k op)
		(define ik-fact (lambda(i acc)
						  (if (< i 1)
							(k acc)
							(ik-fact (- i 1) (op acc i)))))
		(ik-fact N value0)))

	(define show-facts 
	  (lambda(value0 N op)
		(define iloop (lambda(i)
						(when (<= i N)
						  (k-fact value0 i (lambda(e) (display i) 
													  (display " -> ") 
													  (display e) 
													  (newline)) 
								  op)
						  (iloop (+ i 1)))))
		(iloop 1)))
	))
