;; ======================================================================
;; simpleFileReader.scm
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

(declare (unit file-operations))
(declare (uses extras))

(include "../lib/with-exception.inc.scm")

(define safe-open-file
  (lambda (file-name)
	(with-exception return
					(try
					  (lambda()
						(open-input-file file-name)))
					(catch
					  (lambda(exn)
						(printf "Cannot open file ~A -> ~A~%" 
								file-name exn)
						(return #f))))))

(define fill-buffer
  (lambda (fHandle buffer buffer-len)
	(define ifill 
	  (lambda (position count)
		(let ((c (read-byte fHandle)))
		  (cond
			((eof-object? c)
			 (close-input-port fHandle)
			 (list count buffer))
			((= count buffer-len)
			 (list count buffer))
			(else
			  (vector-set! buffer position c)
			  (ifill (+ 1 position) (+ 1 count)))))))
	(ifill 0 0)))


(define simpleFileReader
  (lambda (file-name buffer-size)
	(let ((buffer (make-vector buffer-size))
		  (fHandle (safe-open-file file-name)))
	  (if (not fHandle)
		'()
		(lambda ()
		  (fill-buffer fHandle buffer buffer-size))))))

