;; ======================================================================
;; owl-tools.scm
;; some functions for owl-lisp
;; ======================================================================


(define-library (owl-tools)
				(export newline)
				(import (owl defmac) (owl io) (scheme base))
				(begin
				  (define newline
					(lambda()
					  (display "\n")))
				  ))
