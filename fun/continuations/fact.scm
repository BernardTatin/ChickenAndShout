;; ======================================================================
;; fact.scm
;; une factorielle avec continuation
;; ======================================================================

(define k-fact (lambda(N k)
				 (define ik-fact (lambda(i acc)
								   (if (< i 1)
									 (k acc)
									 (ik-fact (- i 1) (* acc i)))))
				 (ik-fact N 1)))

(define show-facts (lambda(N)
					 (define iloop (lambda(i)
									 (when (<= i N)
									   (k-fact i (lambda(e) (display e) (newline)))
									   (iloop (+ i 1)))))
					 (iloop 1)))

(show-facts 10)

