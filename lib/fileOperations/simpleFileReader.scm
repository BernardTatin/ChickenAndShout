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

;; (declare (unit file-operations))
;; (declare (uses extras))

(define-library 
  (simpleFileReader)
  (export simpleFileReader fill-buffer safe-open-file)
  (import (scheme base) (scheme write) (scheme read) (scheme process-context) 
		  (scheme file) (slprintf))


  (begin
	(cond-expand
	  (chicken
		(begin
		  (require-extension matchable)	;; for match
		  (declare (uses extras))))
	  (foment (define read-byte read-utf8))
	  (sagittarius
		(define read-byte
		  (lambda (handle)
			(let ((buf (make-bytevector 1)))
			  (let ((n (read-bytevector! 1 handle)))
				(if (eof-object? n)
				  n
				  (vector-ref buf 0)))))))
	  (else #t))

	;; (include "with-exception.inc.scm")
    (define-syntax with-exception
      (syntax-rules (try catch)
        ((with-exception (try <dotry>) (catch <docatch>))
         (guard 
          (exc (else <docatch>))
          (begin 
            (let ((r <dotry>))
              (slprintf "<end of dotry>\n")
              r) )))))

	(define safe-open-file
	  (lambda (file-name)
		(display "opening ") (display file-name) (newline)
		(with-exception (try
							(open-input-file file-name))
						(catch
							(slprintf "Cannot open file %s -> ??\n" 
									file-name)
							))))

    (define fill-buffer
      (lambda (fHandle buffer buffer-len)

        (let ((ifill
               (lambda (position count)
                 (let ((c (read-byte fHandle)))
                   (slprintf "position %08x count %02d buffer-len %02d\n" position count buffer-len)
                   (slprintf "get c %02x!!!\n" c)
                   (cond
                    ((eof-object? c)
                     (slprintf "EOF !!! position %08x count %02d buffer-len %02d\n" position count buffer-len)
                     (close-input-port fHandle)
                     (list count buffer))
                    ((= count buffer-len)
                     (slprintf "count == buffer-len !!! position %08x count %02d buffer-len %02d\n" position count buffer-len)
                     (list count buffer))
                    (else
                     (slprintf "VECTOR SET !!! position %08x count %02d buffer-len %02d\n" position count buffer-len)
                     (vector-set! buffer position c)
                     (ifill (+ 1 position) (+ 1 count))))))))

              (slprintf "in fill-buffer\n")
              (let ((r (ifill 0 0)))
                (slprintf "fin de ifill\n")
                r))
        ))


	(define simpleFileReader
	  (lambda (file-name buffer-size)
		(let ((buffer (make-vector buffer-size))
			  (fHandle (safe-open-file file-name)))
		  (if (not fHandle)
			'()
			(lambda ()
			  (fill-buffer fHandle buffer buffer-size))))))
	))
