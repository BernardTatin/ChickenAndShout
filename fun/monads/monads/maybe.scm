;; #!r7rs
;; ======================================================================
;; maybe.scm
;; ======================================================================

;; ----------------------------------------------------------------------
;; monad maybe
;; from 'Monads for Schemers/Lispers'
;;		(https://metalinguist.wordpress.com/2007/07/21/monads-for-schemerslispers/)
;; ----------------------------------------------------------------------


(define-library 
  (monads maybe)
  (export make-maybe
		  map-function-to-maybe
		  join-maybe)
  (cond-expand
	(owl-lisp
	  (import (owl defmac)
			  (scheme base)))
        (racket
         (import (racket base)))
	(else
	  (import (scheme base))))

  (begin
	(define make-maybe 
	  (lambda(value)
		value))

	(define map-function-to-maybe 
	  (lambda(fn test? on-test-true)
		(lambda (maybe-object)
		  (if (test? maybe-object)
			on-test-true
			(make-maybe (fn maybe-object))))))

	(define join-maybe 
	  (lambda(maybe-object)
		maybe-object))))


