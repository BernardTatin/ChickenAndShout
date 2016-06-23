;; ======================================================================
;; slprintf-test.scm
;; date		: 2016-03-21 23:04
;; author	: bernard
;;
;; The MIT License (MIT)
;; 
;; Copyright (c) 2016 Bernard Tatin
;; 
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;; 
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;
;; ========================================================================
;;
;; Usage :
;; gosh -I ../tools -I ../bbmatch -I . ./slprintf-test.sc
;; sagittarius -L ../tools -L ../bbmatch -L . ./slprintf-test.scm
;; foment -I ../tools -I ../bbmatch -I .  ./slprintf-test.scm
;; ========================================================================

(import (scheme base) (exception) (slprintf) (println))

(define number-loop
  (lambda (N)
	(if (< N 0)
	  0
	  (begin
		(slprintf "loop %3d -> %02x -> %08b\n" N N N)
		(number-loop (- N 1))))))

(define test-main
  (lambda()
    (newline)
	(number-loop 255)
    (slprintf "str %s(coucou) int %3d (5) le d ne passe %s (pas)?\n<EOL> mais si! hex %03x (23 -> 0x17) %c ('a')\n" 
			   "coucou" 5 "pas" 23 #\a)
	(guard (except (else (print-exception except)))
		   (slprintf "with error : %d\n" "raté"))
	(guard (except (else (print-exception except)))
		   (slprintf "with error : %c\n" 32))
    (cond-expand
     (foment (println "No bad call test"))
     (else
      (guard (except (else (print-exception except)))
		   (format-char "Ho!"))))
	(println "Fin du test!")))



(test-main)

