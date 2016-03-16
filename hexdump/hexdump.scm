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

(require-extension matchable)

(declare (uses extras))		;; Chicken specific

(define *app-name* (car (argv)))
(define *app-vers* "0.0.1")

(define dohelp
  (lambda (exit-code)
	(printf "~A [--help] : this text~%" *app-name*)
	(printf "~A file file ... : make an hexdump of all these files~%" *app-name*)
	(exit exit-code)))

(define hexint
  (lambda(addr)
	(let* ((s (sprintf "00000000~X" addr))
		   (l (string-length s)))
	  (substring s (- l 8) l))))

(define hexchar
  (lambda(count)
	(if (not (= 0 count))
	  (let ((c (read-byte)))
		(if (eof-object? c)
		  c
		  (begin
			(let ((cc c))
			  (if (< cc 16)
				(printf "0~X " cc) 
				(printf "~X " cc))
			  (hexchar (- count 1))))))
	  0)))

(define hexline
  (lambda (address)
	(printf "~%~A : " (hexint address))
	(when (not (eof-object? (hexchar 16)))
	  (hexline (+ address 16)))))

(define hexd
  (lambda (files)
	(if (not (null? files))
		(let ((current-file (car files))
			  (rest (cdr files))
			  (address 0))
		  (printf "~A~%" current-file)
		  (with-input-from-file current-file
								(lambda() 
								  ;; ------------------------------------
								  (hexline address)))
		  (printf "~%")
		  (hexd rest)))))

(define main
  (lambda ()
	(let ((args (cdr (argv))))
	  (match args
			 (() (dohelp 0))
			 (("--help") (dohelp 0))
			 (_ (hexd args))))))

(main)
