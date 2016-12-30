;; ======================================================================
;; owl-fact.scm
;; ======================================================================

(import (owl defmac) (owl io) (scheme base) (owl-tools) (fact))
(lambda(args)
  (show-facts 1 (string->number (car (cdr args))) *))

