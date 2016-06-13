;; ========================================================================
;; println.scm
;; ========================================================================

(define-library 
  (println)
  (export println err-println)
  (import (scheme base) (scheme write))

  (begin
	(define (println . args)
	  (for-each display args)
	  (newline))
	
	(define (err-println . args)
	  (display "ERROR: ")
	  (for-each display args)
	  (newline))
	))
