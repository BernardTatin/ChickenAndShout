;; ========================================================================
;; format-string.scm
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
;; ======================================================================
;; ========================================================================

(define-library 
  (slprintf format format-string)
  (export format-string)
  (cond-expand
	(owl-lisp
	  (import (owl defmac) 
			  (owl io) 
			  (scheme base) 
			  (tools exception)))
	(else
	  (import (scheme base) 
			  (tools exception))))
  (begin

	(define format-string
	  (lambda(value filler len)
		(cond
		  ((null? value)
			 "<null>")
		  ((pair? value)
			 (format-string (car value) filler len))
		  ((string? value)
		   (let* ((l (string-length value))
				  (d (- len l)))
			 (if (> d 0)
			   (string-append (make-string d filler) value)
			   value)))
		  (else
			(raise-exception 'ERROR 'format-string "String expected")))))

  ))
