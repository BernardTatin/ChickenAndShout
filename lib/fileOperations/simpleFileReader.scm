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
         (println) (slprintf) 
         (scheme file))


 (begin
   (cond-expand
    (chicken
     (begin
       (require-extension matchable)	;; for match
       (declare (uses extras))))
    ((or gauche foment sagittarius) (define read-byte read-u8))
    (else #t))

   (cond-expand
    (foment (include "../with-exception.inc.scm"))
    (else (include "../lib/with-exception.inc.scm")))


   (define safe-open-file
     (lambda (file-name)
       (display "opening ") (display file-name) (newline)
       (with-exception (try
                        (cond-expand
                         (foment (open-binary-input-file file-name))
                         (else (open-input-file file-name :transcoder #f))))
                       (catch
                           (begin
                             #f
                             )
                           ))))

   (define fill-buffer
     (lambda (fHandle buffer buffer-len)

       (define ifill
         (lambda (position count)
           (let ((c (read-byte fHandle)))
             (cond
              ((eof-object? c)
               (list count buffer))
              ((= count (- buffer-len 1))
               (vector-set! buffer position c)
               (list (+ count 1) buffer))
              (else
               (vector-set! buffer position c)
               (ifill (+ 1 position) (+ 1 count)))))))

       (ifill 0 0)))


   (define simpleFileReader
     (lambda (file-name buffer-size)
       (let ((buffer (make-vector buffer-size))
             (fHandle (safe-open-file file-name)))
         (if (not fHandle)
             #f
             (lambda ()
               (let ((r (fill-buffer fHandle buffer buffer-size)))
                 (when (= 0 (car r))
                   (close-input-port fHandle))
                 r))))))
   ))
