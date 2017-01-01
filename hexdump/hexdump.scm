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
;; Test :
;;		sagittarius -r 7 -L ../lib -L . ./hexdump.scm  ../**/*.md pipo
;;		gosh -r 7 -I ../lib -I . ./hexdump.scm  ../**/*.md pipo
;;		foment -I ../lib -I . ./hexdump.scm  ../**/*.md pipo
;; ======================================================================

(define-library
  (hexdump)
  (export file-hexdump)
  (cond-expand
	(owl-lisp
	  (import (owl defmac) (owl io) 
			  (scheme base) (scheme write)
			  (slprintf slprintf) (slprintf format format-int) 
			  (tools exception)
			  (bbmatch bbmatch) (helpers) (fileOperations binFileReader)))
	(sagittarius
	  (import (scheme base) (scheme write) (match)
			  (slprintf slprintf) (slprintf format format-int) 
			  (tools exception)
			  (helpers) (fileOperations binFileReader)))
	(chicken
	  (import (scheme base) (scheme write) (matchable)
			  (slprintf slprintf) (slprintf format format-int) 
			  (tools exception)
			  (helpers) (fileOperations binFileReader)))
	(else
	  (import (scheme base) (scheme write)
			  (slprintf slprintf) (slprintf format format-int) 
			  (tools exception)
			  (bbmatch bbmatch) (helpers) (fileOperations binFileReader))))

  (begin

	(define bufferLen	16)

	(define format-hex2
	  (lambda(x)
		(let ((r (number->string x 16)))
		  (if (< x 16)
			(string-append "0" r)
			r))))

	(define format-address
	  (lambda(address)
		(let* ((s (number->string address 16))
			   (d (- 8 (string-length s))))
		  (if (> d 0)
			(string-append (make-string d #\0) s)
			s))))

	(define fold-left 
	  (lambda(op initial sequence)
		(define iter 
		  (lambda(result rest)
			(if (null? rest)
			  result
			  (iter (op result (car rest)) (cdr rest)))))
		(iter initial sequence)))

	(define file-hexdump
	  (lambda (files)
		(when (not (null? files))
		  (let ((current-file (car files)))
			(define ixdump
			  (lambda (rs)
				(match rs
					   ((0 _ address) 
						(slprintf "%s" (format-address address))
						#f)
					   ((rcount list-buffer address)
						(let ((str-address (format-address address))
							  (all-hex (map format-hex2 list-buffer))
							  (all-ascii (map (lambda(x)
												(cond
												  ((< x 32) ".")
												  ((> x 126) ".")
												  (else (string (integer->char x)))
												  ))
											  list-buffer)))
						  (slprintf "%s  %s |%s|\n"
									str-address
									(fold-left (lambda(x y)
												 (string-append x y " "))
											   ""
											   all-hex)
									(apply string-append all-ascii))

						  #t)))))

			(define xdump 
			  (lambda (fileReader)
				(define ixd (lambda ()
							  (when (fileReader)
								(ixd))))
				(ixd)))

			(with-exception 
			  (try
				(let ((fileReader (binFileReader current-file bufferLen ixdump)))
				  (when fileReader
					(xdump fileReader))))
			  (catch
				(slprintf "[ERROR] Cannot process file %s\n" current-file)))

			(display "\n")
			(file-hexdump (cdr files))))))

	))

;; gosh and sagittarius need this define-library in order to
;; use cond-expand

(define-library
  (main-entry-point)
  (export themain)
  (cond-expand
	(chicken
	  (import (scheme base) (scheme write) (scheme process-context)
			  (slprintf println) (slprintf slprintf)
			  (hexdump)
			  (matchable) (helpers)))
	(sagittarius
	  (import (scheme base) (scheme write) (scheme process-context)
			  (slprintf println) (slprintf slprintf)
			  (hexdump)
			  (match) (helpers)))
	(else
	  (import (scheme base) (scheme write) (scheme process-context)
			  (slprintf println) (slprintf slprintf)
			  (hexdump)
			  (bbmatch bbmatch) (helpers))))

  (begin
	(define themain
	  (lambda (args)
		(let ((_args (cdr args)))
		  (match _args
				 (() (dohelp 0))
				 (("--help") (dohelp 0))
				 (("--help" _) (dohelp 0))
				 (("--version") (doversion 0))
				 (("--version" _) (doversion 0))
				 (else (file-hexdump _args))))))
	(themain (command-line))))
