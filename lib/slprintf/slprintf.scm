;; ========================================================================
;; slprintf.scm
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
;; ========================================================================

(define-library
  (slprintf slprintf)
  (export slprintf)
  (cond-expand
	(owl-lisp
	  (import (owl defmac) 
			  (owl io) 
			  (scheme base) 
			  (scheme write) 
			  (scheme char) 
			  (tools exception)
			  (slprintf format format-string) 
			  (slprintf format format-int) 
			  (slprintf format format-char)))
	(chicken
	  (import (scheme base) 
			  (scheme write) 
			  (scheme char) 
			  (matchable)
			  (tools exception)
			  (slprintf format format-string) 
			  (slprintf format format-int) 
			  (slprintf format format-char)))
	(else
	  (import (scheme base) 
			  (scheme write) 
			  (scheme char) 
			  (bbmatch bbmatch)
			  (tools exception)
			  (slprintf format format-string) 
			  (slprintf format format-int) 
			  (slprintf format format-char))))

  (begin

	
    ;; idée limite: faire une macro pour obtenir une constante...
    (define-syntax default-filler
      (syntax-rules ()
        ((default-filler) #\space)))

    (define-syntax default-len
      (syntax-rules ()
        ((default-len) -1)))
    
	(define (slprintf format . all-args)
      (when (not (string? format))
        (raise-exception 'ERROR 'sl-printf "format must be a string"))
	  (let ((lformat (string->list format)))
		(letrec ((display-and-deformat
				   (lambda(strs lst-of-chars args)
                     (display strs)
					 (deformat (cdr lst-of-chars) args #f (default-filler) (default-len))))
				 (on-else
				   (lambda(c lst-of-chars args)
					 (display c)
					 (deformat (cdr lst-of-chars) args #f (default-filler) (default-len))))
				 (deformat
				   (lambda(lst-of-chars args in-format filler len)
					 (if (not (null? lst-of-chars))
					   (let ((c (car lst-of-chars)))
						 (case c
						   ((#\newline) (newline)
										(deformat (cdr lst-of-chars) args #f (default-filler) (default-len)))
						   ((#\%) (deformat (cdr lst-of-chars) args #t (default-filler) (default-len)))
						   ((#\space #\0) (if in-format
											(deformat (cdr lst-of-chars) args #t c (default-len))
											(on-else c lst-of-chars args)))
						   ((#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9) (if in-format
																	(deformat (cdr lst-of-chars) args #t filler (- (char->integer c) (char->integer #\0)))
																	(on-else c lst-of-chars args)))
						   ((#\s) (if in-format
									(display-and-deformat (format-string (car args) #\space -1) lst-of-chars (cdr args))
									(on-else c lst-of-chars args)))
						   ((#\x) (if in-format
									(display-and-deformat (format-int (car args) filler len 16) lst-of-chars (cdr args))
									(on-else c lst-of-chars args)))
						   ((#\b) (if in-format
									(display-and-deformat (format-int (car args) filler len 2) lst-of-chars (cdr args))
									(on-else c lst-of-chars args)))
						   ((#\d) (if in-format
									(display-and-deformat (format-int (car args) filler len 10) lst-of-chars (cdr args))
									(on-else c lst-of-chars args)))
						   ((#\c) (if in-format
									(display-and-deformat (format-char (car args)) lst-of-chars (cdr args))
									(on-else c lst-of-chars args)))
						   (else
                            (if in-format
                                (raise-exception 'ERROR 'sl-printf "Bad format definition")
                                (display-and-deformat c lst-of-chars args)))))
					   #t))))
		  (deformat lformat all-args #f (default-filler) (default-len)))))

	))
