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
  (export sprintf slprintf)
  (cond-expand
	(owl-lisp
	  (import (owl defmac) 
			  (owl io) 
			  (scheme base) 
			  (scheme write) 
			  (scheme char) 
			  (tools exception)
			  (slprintf values)
			  (slprintf format format-string) 
			  (slprintf format format-int) 
			  (slprintf format format-char)))
	(else
	  (import (scheme base) 
			  (scheme write) 
			  (scheme char) 
			  (tools exception)
			  (slprintf values)
			  (slprintf format format-string) 
			  (slprintf format format-int) 
			  (slprintf format format-char))))

  (begin

	(define ksprintf 
	  (lambda args 
		(let ((format (car args))
			  (all-args (cdr args)))
		  
		  (when (not (string? format))
			(raise-exception 'ERROR 'sprintf "format must be a string"))
		  (let ((lformat (string->list format)))
			(letrec ((onstr-unformat
					   (lambda(strs lst-format args acc)
						 (unformat (cdr lst-format) 
								   args 
								   #f 
								   (default-filler) 
								   (default-len)
								   (cons strs acc))))

					 (oncar-unformat
					   (lambda(c lst-format args acc)
						 (unformat (cdr lst-format) 
								   args 
								   #f 
								   (default-filler) 
								   (default-len)
								   (cons (string c) acc))))



					 (unformat
					   (lambda(lst-format args in-format filler len acc)
						 (if (not (null? lst-format))
						   (let ((c (car lst-format)))
							 (case c
							   ((#\newline) 
								(oncar-unformat c lst-format args acc))
							   ((#\%) 
								(unformat (cdr lst-format) 
										  args #t 
										  (default-filler) 
										  (default-len) acc))
							   ((#\space #\0) 
								(if in-format
								  (unformat (cdr lst-format) 
											args 
											#t 
											c 
											(default-len) acc)
								  (oncar-unformat c lst-format args acc)))
							   ((#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9) 
								(if in-format
								  (unformat (cdr lst-format) 
											args 
											#t 
											filler 
											(- (char->integer c) 
											   (char->integer #\0)) acc)
								  (oncar-unformat c lst-format args acc)))
							   ((#\s) 
								(if in-format
								  (onstr-unformat (format-string 
													(car args) 
													#\space -1) 
												  lst-format 
												  (cdr args) acc)
								  (oncar-unformat c lst-format args acc)))
							   ((#\x) 
								(if in-format
								  (onstr-unformat (format-int 
													(car args) 
													filler 
													len 
													16) 
												  lst-format 
												  (cdr args) acc)
								  (oncar-unformat c lst-format args acc)))
							   ((#\b) 
								(if in-format
								  (onstr-unformat 
									(format-int (car args) 
												filler 
												len 
												2) 
									lst-format 
									(cdr args) acc)
								  (oncar-unformat c lst-format args acc)))
							   ((#\d) 
								(if in-format
								  (onstr-unformat 
									(format-int (car args) 
												filler 
												len 
												10) 
									lst-format 
									(cdr args) acc)
								  (oncar-unformat c lst-format args acc)))
							   ((#\c) 
								(if in-format
								  (onstr-unformat 
									(format-char (car args)) 
									lst-format 
									(cdr args) acc)
								  (oncar-unformat c lst-format args acc)))
							   (else
								 (if in-format
								   (raise-exception 'ERROR 'sl-printf "Bad format definition")
								   (oncar-unformat c lst-format args acc)))))
						   acc))))
			  (reverse 
				(unformat lformat 
						  all-args 
						  #f 
						  (default-filler) 
						  (default-len)
						  '())))))))


	(define raw-list-to-string
	  (lambda (ks)
		(cond
		  ((null? ks) "")
		  (else
			(apply string-append ks)))))

	(define (sprintf . args)
	  (with-exception
		(try 
		  (raw-list-to-string (apply ksprintf args)))
		(catch
		  "oups!!!")))

	(define slprintf 
	  (lambda all-args
		(display (apply sprintf all-args))))

	))
