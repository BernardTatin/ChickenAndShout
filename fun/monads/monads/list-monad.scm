;; ======================================================================
;; list-monad.scm
;; ======================================================================

;; ----------------------------------------------------------------------
;; monad list
;; from 'Monads for Schemers/Lispers'
;;		(https://metalinguist.wordpress.com/2007/07/21/monads-for-schemerslispers/)
;; ----------------------------------------------------------------------

(define-library
  (monads list-monad)
  (export make-list
		  map-function-to-list
		  join-list)
  (cond-expand
	(owl-lisp
	  (import (owl defmac)
			  (scheme base)))
	(else
	  (import (scheme base))))

  (begin
	(define make-list 
	  (lambda(value)
		(list value)))

	(define map-function-to-list 
	  (lambda(fn)
		(lambda (list-object)
		  ;; "Map" has the proper return type "for free"
		  (map fn list-object))))

	(define join-list 
	  (lambda(value)
		(apply append value)))))
