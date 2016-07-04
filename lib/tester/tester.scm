;; ======================================================================
;; tester.scm
;; unit tester
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
 (tester tester)
 (import (scheme base) (scheme write) (scheme time) (slprintf println))
 (export test-begin test-end test-equal)
 (begin

   (define *pass* 0)
   (define *fail* 0)
   (define *start* 0)

   (define current-milliseconds
     (lambda()
       (* 1000.0 (current-second))))

   (define (run-test name thunk expect eq pass-msg fail-msg)
     (guard (except (else
                     (begin
                       (set! *fail* (+ *fail* 1))
                       (format-result fail-msg name expect except))))

      (let ((result (thunk)))
        (cond
         ((eq expect result)
          (set! *pass* (+ *pass* 1))
          (format-result pass-msg name expect result))
         (else
          (set! *fail* (+ *fail* 1))
          (format-result fail-msg name expect result))))))

   (define (format-result ls name expect result)
     (let inner-format ((ls ls))
       (cond
        ((null? ls)
         (newline))
        ((eq? (car ls) 'expect)
         (display expect)
         (inner-format (cdr ls)))
        ((eq? (car ls) 'result)
         (display result)
         (inner-format (cdr ls)))
        ((eq? (car ls) 'name)
         (when name
           (begin (display #\space) (display name)))
         (inner-format (cdr ls)))
        (else
         (display (car ls))
         (inner-format (cdr ls))))))

   (define (format-float n prec)
     (let* ((str (number->string n))
            (len (string-length str)))
       (let inner-format ((i (- len 1)))
         (cond
          ((negative? i)
           (string-append str "." (make-string prec #\0)))
          ((eqv? #\. (string-ref str i))
           (let ((diff (+ 1 (- prec (- len i)))))
             (cond
              ((positive? diff)
               (string-append str (make-string diff #\0)))
              ((negative? diff)
               (substring str 0 (+ i prec 1)))
              (else
               str))))
          (else
           (inner-format (- i 1)))))))

   (define (format-percent num denom)
     (let ((x (if (zero? denom) num (inexact (/ num denom)))))
       (format-float (* 100 x) 2)))

   (define-syntax test-assert
     (syntax-rules ()
       ((_ name expr) (run-assert name (lambda () expr)))
       ((_ expr) (run-assert 'expr (lambda () expr)))))

   (define (run-equal name thunk expect eq)
     (run-test name thunk expect eq
      '("(PASS)" name)
      '("(FAIL)" name ": expected " expect " but got " result)))

   (define (test-begin . o)
     (for-each display o)
     (newline)
     (set! *pass* 0)
     (set! *fail* 0)
     (set! *start* (current-milliseconds)))

   (define (test-end . o)
     (let ((end (current-milliseconds))
           (total (+ *pass* *fail*)))
       (println "  " total " tests completed in " (format-float (inexact (/ (- end *start*) 1000)) 3) " seconds")
       (println "  " *pass* " (" (format-percent *pass* total) "%) tests passed")
       (println "  " *fail* " (" (format-percent *fail* total) "%) tests failed")))

   (define-syntax test-equal
     (syntax-rules ()
       ((_ name expr value eq) (run-equal name (lambda () expr) value eq))
       ((_ name expr value) (run-equal name (lambda () expr) value equal?))
       ((_ expr value) (run-assert 'expr (lambda () expr) value equal?))))


   ))
