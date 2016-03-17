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
(declare (uses extras))			;; for printf and read-byte

(define *app-name* (car (argv)))
(define *app-vers* "0.0.1")

(define dohelp
  (lambda (exit-code)
	(printf "~A [--help] : this text and exits~%" *app-name*)
	(printf "~A --version : show the version and exits~%" *app-name*)
	(printf "~A file file ... : make an hexdump of all these files~%" *app-name*)
	(exit exit-code)))

(define doversion
  (lambda (exit-code)
	(printf "~A version ~A~%" *app-name* *app-vers*)
	(printf "   (more informations with : ~A --help)~%" *app-name*)
	(exit exit-code)))

;; we use a closure to have one zeroes creation
;; (bad english, bad comment or both?)
(define hexgenerator
  (lambda(length)
	(let ((zeroes (make-string length #\0)))

	  (define hexint
		(lambda(value)
		  (let* ((s (sprintf "~A~X" zeroes value))
				 (l (string-length s)))
			(substring s (- l length) l))))
	  hexint)))

(define hex2 (hexgenerator 2))
(define hex8 (hexgenerator 8))

(define hexchar
  (lambda(count)
	(if (not (= 0 count))
	  (let ((c (read-byte)))
		(if (eof-object? c)
		  c
		  (begin
			(printf "~A " (hex2 c))
			(hexchar (- count 1)))))
	  0)))

(define hexline
  (lambda (address)
	(printf "~%~A " (hex8 address))
	(when (not (eof-object? (hexchar 16)))
	  (hexline (+ address 16)))))

(define hexd
  (lambda (files)
	(when (not (null? files))
	  (let ((current-file (car files))
			(rest (cdr files))
			(address 0))
		;;; NOTE: 
		;;; with-exception-handler goes back wher the exception raise
		;;; so we can have an infinite loop
		;;; call-with-current-continuation help us to prevent this
		(call-with-current-continuation
		  (lambda (k)
			(with-exception-handler
			  (lambda(exn)
				(printf "Cannot open ~A~%" current-file)
				(k '()))
			  (lambda()
				(with-input-from-file current-file
									  (lambda() 
										(hexline address)))))))
		(printf "~%")
		(hexd rest)))))

(define main
  (lambda ()
	(let ((args (cdr (argv))))
	  (match args
			 (() (dohelp 0))
			 (("--help") (dohelp 0))
			 (("--help" _) (dohelp 0))
			 (("--version") (doversion 0))
			 (("--version" _) (doversion 0))
			 (_ (hexd args))))))

(main)
