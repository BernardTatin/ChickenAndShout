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
  (import
	(scheme base) (scheme write) (scheme process-context)
	(slprintf slprintf) (slprintf format format-int) 
	(tools exception)
	(bbmatch bbmatch) (helpers) (fileOperations binFileReader))

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
			   (l (string-length s))
			   (d (- 8 l)))
		  (if (> d 0)
			(string-append (make-string d #\0) s)
			s))))

	(define file-hexdump
	  (lambda (files)
		(when (not (null? files))
		  (let ((current-file (car files)))


			(define ixdump
			  (lambda (rs)
				(match rs
					   ((0 _ address) 
						(display (format-address address))
						(display ":\n")
						#f)
					   ((rcount buffer address)
						(display (format-address address))
						(display "  ")
						(let ((real-buffer (if (< rcount bufferLen)
											 (vector-copy buffer 0 rcount)
											 buffer)))
						  (vector-for-each (lambda(x) 
											 (display (format-hex2 x))
											 (display " "))
										   real-buffer)
						  (display " |")
						  (vector-for-each (lambda(x)
											 (display
											   (cond
												 ((< x 32) #\.)
												 ((> x 126) #\.)
												 (else (integer->char x))
												 )))
										   real-buffer)
						  (display "|\n")
						  (when (< rcount bufferLen)
							(display (format-address (+ address rcount)))
							(display "\n")))

						#t))))


			(define xdump (lambda (fileReader)
							(define ixd (lambda ()
										  (when (fileReader)
											(ixd))))
							(ixd)))

			(with-exception (try
							  (let ((fileReader (binFileReader current-file bufferLen ixdump)))
								(when fileReader
								  (xdump fileReader))))
							(catch
							  (slprintf "[ERROR] Cannot process file %s\n" current-file)))

			(slprintf "\n")
			(file-hexdump (cdr files))))))

	))

(import
  (scheme base) (scheme write) (scheme process-context)
  (slprintf println) (slprintf slprintf)
  (hexdump)
  (bbmatch bbmatch) (helpers) (fileOperations fileReader))

(define main
  (lambda (args)
	(let ((_args (cdr (command-line))))
	  (match (cdr args)
			 (() (dohelp 0))
			 (("--help") (dohelp 0))
			 (("--help" _) (dohelp 0))
			 (("--version") (doversion 0))
			 (("--version" _) (doversion 0))
			 (_ (file-hexdump (cdr args)))))))

(cond-expand
  (foment (main (command-line)))
  (gauche (main (command-line)))
  (else #t))
