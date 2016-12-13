;; ======================================================================
;; test-monad.scm
;; ======================================================================

(import (owl defmac)
		(owl io)
		(scheme base)
		(maybe))

;; ----------------------------------------------------------------------
;; test

(display ";; ----------------------------------------------------------------------\n")
(display "(define maybe-cdr (map-function-to-maybe cdr))\n")
(let ((maybe-cdr (map-function-to-maybe cdr))
	  (object (make-maybe '(1 2))))

  (display "(maybe-cdr (make-maybe '(1 2))) \n\texpect -> (2) \n\tget -> ")
  (display (maybe-cdr object))
  (display "\n")

  (display "(maybe-cdr (maybe-cdr (make-maybe '(1 2)))) \n\texpect -> () \n\tget -> ")
  (display (maybe-cdr (maybe-cdr object)))
  (display "\n")

  (display "(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (make-maybe '(1 2)))))) \n\texpect -> Error \n\tget -> ")
  (display (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object)))))
  (display "\n")

  (display "(maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (make-maybe '(1 2))))))) \n\texpect -> Error \n\tget -> ")
  (display (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr (maybe-cdr object))))))
  (display "\n")
  (display "\n")
  (display "\n")

  (display "last compute is same as :\n")
  (display "(cdr (cdr (cdr (cdr '(1 2))))) \n\tget -> ")
  (display (cdr (cdr (cdr (cdr '(1 2))))))
  (display "\n"))

