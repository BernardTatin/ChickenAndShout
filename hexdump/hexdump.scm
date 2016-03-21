;; ======================================================================
;; hexdump.scm
;; date		: 2016-03-16 22:20
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

;; chicken specific, call for libs
(require-extension matchable)	;; for match
(declare (uses extras))
;; local libs
(declare (uses helpers))
(declare (uses hextools))

(define hex2 (hexgenerator 2))
(define hex8 (hexgenerator 8))

(define byte-hexdump
  (lambda(count)
	(if (not (= 0 count))
	  (let ((c (read-byte)))
		(if (eof-object? c)
		  c
		  (begin
			(printf "~A " (hex2 c))
			(byte-hexdump (- count 1)))))
	  0)))

(define line-hexdump
  (lambda (address)
	(printf "~%~A " (hex8 address))
	(when (not (eof-object? (byte-hexdump 16)))
	  (line-hexdump (+ address 16)))))

;;; NOTE: 
;;; with-exception-handler goes back where the exception raise
;;; so we create an infinite loop
;;; call-with-current-continuation help us to prevent this
;;; PS: must find better names?
(define-syntax with-exception
  (syntax-rules (try catch)
	((with-exception <return> (try <dotry>) (catch <docatch>))
	 (call-with-current-continuation
	   (lambda (<return>)
		 (with-exception-handler
		   <docatch>
		   <dotry>))))))

(define file-hexdump
  (lambda (files)
	(when (not (null? files))
	  (let ((current-file (car files))
			(rest (cdr files))
			(address 0))
		(with-exception return
			(try
			  (lambda()
				(with-input-from-file current-file
									  (lambda() 
										(line-hexdump address)))))
			(catch
			  (lambda(exn)
				(printf "Cannot open file ~A -> ~A~%" current-file exn)
				(return #f))))

		(printf "~%")
		(file-hexdump rest)))))

(define main
  (lambda ()
	(let ((args (cdr (argv))))
	  (match args
			 (() (dohelp 0))
			 (("--help") (dohelp 0))
			 (("--help" _) (dohelp 0))
			 (("--version") (doversion 0))
			 (("--version" _) (doversion 0))
			 (_ (file-hexdump args))))))

(main)
