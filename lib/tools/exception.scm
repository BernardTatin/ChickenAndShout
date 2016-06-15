;; ======================================================================
;; execption.scm
;; date		: 2016-03-21 23:04
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
;; ======================================================================

(define-library
 (exception)
 (import (scheme base) (println))
 (export raise-exception print-exception)
 (begin
   
   (define-record-type <exception>
     (make-exception type     ;; error, fatal error, warning...
                     source   ;; file, function
                     text)
     exception?
     (type exception-type)
     (source exception-source)
     (text exception-text))
   
   (define raise-exception
     (lambda (type source text)
       (raise (make-exception type source text))))
   
   (define print-exception
     (lambda (exception)
       (cond
        ((string? exception) (println "ERROR: " exception))
        ((exception? exception) (println (exception-type exception) ": " 
                                         (exception-source exception) " - " 
                                         (exception-text exception)))
        (else (println "ERROR of unexpected type: " exception)))))
   
   ))
 
