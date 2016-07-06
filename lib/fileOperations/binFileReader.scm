;; ======================================================================
;; binFileReader.scm
;; date		: 2016-06-06 22:54
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
  (fileOperations binFileReader)
  (export binFileReader)
  (import (scheme base) (scheme read) (scheme file)
		  (bbmatch bbmatch)
		  (fileOperations safe-open-file) (tools exception))


  (begin
	(cond-expand
	  ((or gauche foment sagittarius) (define read-byte read-u8))
	  (else #t))

	(define binFileReader
	  (lambda (file-name buffer-size k)

		(define control-state
		  (lambda (return)
			(let ((buffer (make-vector buffer-size))
				  (fHandle (safe-open-file file-name)))

			  (define ifill
				(lambda (position count)
				  (let ((c (read-byte fHandle)))
					(cond
					  ((eof-object? c)
					   (list count buffer))
					  ((= count (- buffer-size 1))
					   (vector-set! buffer position c)
					   (list (+ count 1) buffer))
					  (else
						(vector-set! buffer position c)
						(ifill (+ 1 position) (+ 1 count)))))))

			  (letrec ((loop 
						 (lambda(position count)
						   (let ((rs (ifill position count)))
							 (match rs
									((0 _) (return #f))
									((count buf)
									 (set! return (call-with-current-continuation
													(lambda(resume-here)
													  (set! control-state resume-here)
													  (return (k rs)))))
									 (loop 0 0))
									)))))
				(loop 0 0)))))

		(define (generator)
		  (call-with-current-continuation control-state))

		;; Return the generator 
		generator))

	))
