;; ======================================================================
;; hex-tests.scm
;; date		: 2016-06-15 22:41
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
;; ======================================================================

(define-library 
  (hex-tests)
  (import (scheme base) (scheme write) (slprintf slprintf)
		  (hextools) (tester tester))

  (begin
	(let ((hg (hexgenerator 2)))
      (slprintf "Oh! %d %s\\n" 5 "cinq")
	  (test-begin "\n\n" "*** test hextools ***")
	  (test-equal "(hg 0) -> 00" (hg 0) "00")
	  (test-equal "(hg 1) -> 01" (hg 1) "01")
	  (test-equal "(hg 2) -> 01" (hg 2) "01")
	  (test-equal "(hg 15) -> 0f" (hg 15) "0f")
	  (test-equal "(hg 240) -> f0" (hg 240) "f0")
	  (test-equal "(hg 241) -> f1" (hg 240) "f1")
	  (test-end "test hextools"))))
 
