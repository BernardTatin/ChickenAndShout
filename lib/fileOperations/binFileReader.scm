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
  (cond-expand
	(chicken
	  (import (scheme base) (scheme read) (scheme file)
			  (matchable) ;;(extras)
			  (fileOperations safe-open-file) (tools exception)))
	(gosh
	  (import (scheme base) (scheme read) (scheme file)
			  (utils match)
			  (fileOperations safe-open-file) (tools exception)))
	(sagittarius
	  (import (scheme base) (scheme read) (scheme file)
			  (match)
			  (fileOperations safe-open-file) (tools exception)))
	(else
	  (import (scheme base) (scheme read) (scheme file)
			  (bbmatch bbmatch)
			  (fileOperations safe-open-file) (tools exception))))


  (begin

	(define binFileReader
	  (lambda (file-name buffer-size k)

		(define control-state
		  (lambda (return)
			(let ((fHandle (safe-open-file file-name)))

			  (define bytevector-to-list
				(lambda(byte-vector len)
				  (letrec ((loop
							 (lambda(k acc)
							   (if (< k len)
								 (loop (+ 1 k) 
									   (cons 
										 (bytevector-u8-ref byte-vector k) 
										 acc))
								 acc))))
					(reverse (loop 0 '())))))

			  (define inner-fill-buffer
				(lambda ()
				  (let* ((v (read-bytevector buffer-size fHandle)))
					(cond
					  ((eof-object? v)
					   (list 0 #f))
					  (else
						(let ((bvlen (bytevector-length v)))
						  (list bvlen 
								(bytevector-to-list v bvlen))))))))

			  (letrec ((loop 
						 (lambda(address)
						   (let ((rs (inner-fill-buffer)))
							 (match rs
									((0 _) 
									 (return (k (list rs address))))
									((count _)
									 (set! return (call-with-current-continuation
													(lambda(resume-here)
													  (set! control-state resume-here)
													  (return (k (list rs address))))))
									 (loop (+ address count))))
							 ))))
				(loop 0)))))

		(define (generator)
		  (call-with-current-continuation control-state))

		;; Return the generator 
		generator))

	))
