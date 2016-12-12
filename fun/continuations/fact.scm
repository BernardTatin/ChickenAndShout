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
  (import (owl defmac) (owl io) (owl macro) (scheme base)
		  (owl-tools))
  (begin
	(define k-fact 
	  (lambda(value0 N k op)
		(define ik-fact 
		  (lambda(i acc)
			(case i
				((0 1) (k acc))
				(else (ik-fact (- i 1) (op acc i))))))
		(ik-fact N value0)))

	(define show-facts 
	  (lambda(value0 N op)
		(define iloop 
		  (lambda(i)
			(k-fact value0 i (lambda(e) (display i) 
										(display " -> ") 
										(display e) 
										(newline)) 
					op)
			(when (< i N)
			  (iloop (+ i 1)))))
		(iloop 0)))
	))
