;; ======================================================================
;; maybe.scm
;; ======================================================================

;; ----------------------------------------------------------------------
;; monad maybe
;; from 'Monads for Schemers/Lispers'
;;		(https://metalinguist.wordpress.com/2007/07/21/monads-for-schemerslispers/)
;; ----------------------------------------------------------------------

(define-library 
  (maybe)
  (export make-maybe
		  map-function-to-maybe
		  join-maybe)
  (cond-expand
	(owl-lisp
	  (import (owl defmac)
			  (scheme base)))
	(else
	  (import (scheme base))))

  (begin
	(define make-maybe 
	  (lambda(value)
		value))

	(define map-function-to-maybe 
	  (lambda(fn)
		(lambda (maybe-object)
		  (if (null? maybe-object)
			'()
			(make-maybe (fn maybe-object))))))

	(define join-maybe 
	  (lambda(maybe-object)
		maybe-object))))


