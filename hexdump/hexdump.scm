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
(include "macros.scm")

(define-constant bufferLen	16)

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
	(when (not (eof-object? (byte-hexdump bufferLen)))
	  (line-hexdump (+ address bufferLen)))))


(define file-hexdump
  (lambda (files)
	(when (not (null? files))
	  (let ((current-file (car files))
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
		(file-hexdump (cdr files))))))

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
