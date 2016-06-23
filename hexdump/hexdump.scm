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

#|
;; chicken specific, call for libs
(require-extension matchable)	;; for match
(declare (uses extras))
;; local libs
(declare (uses helpers))
(declare (uses hextools))
(declare (uses file-operations))
(include "macros.scm")
|#

	
(define-library
 (hexdump)
 (export file-hexdump)
 (import
  (scheme base) (scheme write) (scheme process-context)
  (slprintf)
  (bbmatch) (helpers) (simpleFileReader))

 (begin
   (display "Starting...\n")
   (include "../lib/with-exception.inc.scm")

   (define bufferLen	16)


   (define xdump
     (lambda (fileReader)
       (define ixd
         (lambda (address)
           (let* ((result (fileReader))
                  (rcount (car result))
                  (buffer (cadr result)))
             (cond
              ((= 0 rcount)
               #f)
              (else
               (slprintf "%08x " address)
               (let ((real-buffer (if (< rcount bufferLen)
                                      (vector-copy buffer 0 rcount)
                                      buffer)))
                 (vector-for-each (lambda(x) (slprintf "%02x " x))
                  real-buffer)
                 (display " '")
                 (vector-for-each (lambda(x)
                                    (cond
                                     ((< x 42) (display #\.))
                                     ((> x 126) (display #\.))
                                     (else (display (integer->char x)))
                                     ))
                  real-buffer)
                 (display "'\n")
                 )
               (ixd (+ rcount address)))))))
       (ixd 0)))


   (define file-hexdump
     (lambda (files)
       ;; (display "files --> ") (display files) (newline)
       ;; (exit 0)
       (when (not (null? files))
         (let ((current-file (car files))
               (address 0))
           (with-exception (try
                              (let ((fileReader (simpleFileReader current-file bufferLen)))
                                (if fileReader
                                    (xdump fileReader)
                                    (slprintf "cannot process %s !!!\n" current-file))))
                           (catch
                                 (slprintf "[ERROR] Cannot process file %s -> oh ??\n" current-file)
                                 ))

           (slprintf "\n")
           (file-hexdump (cdr files))))))

   ))

(import
 (scheme base) (scheme write) (scheme process-context)
 (slprintf) (hexdump)
 (bbmatch) (helpers) (simpleFileReader))

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