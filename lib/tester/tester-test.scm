;; ======================================================================
;; test.scm
;; unit tester
;; sagittarius -L ../sl-printf -L .  ./tester-test.scm
;; foment -I ../sl-printf -I .  ./tester-test.scm
;; ======================================================================

(import (scheme base) (tester))

(test-begin "\n\n" "*** test tester ***")
(test-equal "'(+ 1 2)" '(+ 1 2) 3)
(test-equal "(+ 1 2)" (+ 1 2) 3)
(test-end "test tester")