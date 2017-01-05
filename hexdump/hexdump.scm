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
			  (slprintf values)
			  (tools exception)
			  (bbmatch bbmatch) (helpers) (fileOperations binFileReader)))
	(gosh
	  (import (scheme base) (scheme write) (util match)
			  (slprintf slprintf) (slprintf format format-int) 
			  (slprintf values)
			  (tools exception)
			  (helpers) (fileOperations binFileReader)))
	(sagittarius
	  (import (scheme base) (scheme write) (match)
			  (slprintf slprintf) (slprintf format format-int) 
			  (slprintf values)
			  (tools exception)
			  (helpers) (fileOperations binFileReader)))
	(chicken
	  (import (scheme base) (scheme write) (matchable)
			  (slprintf slprintf) (slprintf format format-int) 
			  (slprintf values)
			  (tools exception)
			  (helpers) (fileOperations binFileReader)))
	(else
	  (import (scheme base) (scheme write)
			  (slprintf slprintf) (slprintf format format-int) 
			  (slprintf values)
			  (tools exception)
			  (bbmatch bbmatch) (helpers) (fileOperations binFileReader))))

  (begin


	(define-syntax bufferLen
	  (syntax-rules ()
					((bufferLen) 16)))


	(define file-hexdump
	  (lambda (files)
		(when (not (null? files))
		  (let ((current-file (car files)))

			(define ixdump
			  (lambda (rs)
				(match rs
					   ((0 _ address) 
						(slprintf "%08x" address)
						#f)
					   ((_ list-buffer address)
						(let ((all-hex (map (lambda(h)
											  (slsprintf "%02x " h))
											list-buffer))
							  (all-ascii (map (lambda(x)
												(cond
												  ((< x 32) ".")
												  ((> x 126) ".")
												  (else 
													(string 
													  (integer->char x)))))
											  list-buffer)))
						  (slprintf "%08x  %s |%s|\n"
									address
									(apply string-append all-hex)
									(apply string-append all-ascii))

						  #t)))))


			(with-exception 
			  (try
				(let ((fileReader 
						(binFileReader current-file (bufferLen) ixdump)))
				  (define loop
					(lambda (fileReader)
					  (when (fileReader)
						(loop fileReader))))

				  (when fileReader
					(loop fileReader))))
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
	(gosh
	  (import (scheme base) (scheme write) (scheme process-context)
			  (slprintf println) (slprintf slprintf)
			  (hexdump)
			  (utils match) (helpers)))
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
