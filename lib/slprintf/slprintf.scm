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
					   (lambda(strs lst-of-chars args acc)
						 (unformat (cdr lst-of-chars) 
								   args 
								   #f 
								   (default-filler) 
								   (default-len)
								   (cons strs acc))))

					 (oncar-unformat
					   (lambda(c lst-of-chars args acc)
						 (unformat (cdr lst-of-chars) 
								   args 
								   #f 
								   (default-filler) 
								   (default-len)
								   (cons c acc))))



					 (unformat
					   (lambda(lst-of-chars args in-format filler len acc)
						 (if (not (null? lst-of-chars))
						   (let ((c (car lst-of-chars)))
							 (case c
							   ((#\newline) 
								(oncar-unformat c lst-of-chars args acc))
							   ((#\%) 
								(unformat (cdr lst-of-chars) 
										  args #t 
										  (default-filler) 
										  (default-len) acc))
							   ((#\space #\0) 
								(if in-format
								  (unformat (cdr lst-of-chars) 
											args 
											#t 
											c 
											(default-len) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   ((#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9) 
								(if in-format
								  (unformat (cdr lst-of-chars) 
											args 
											#t 
											filler 
											(- (char->integer c) 
											   (char->integer #\0)) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   ((#\s) 
								(if in-format
								  (onstr-unformat (format-string 
													(car args) 
													#\space -1) 
												  lst-of-chars 
												  (cdr args) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   ((#\x) 
								(if in-format
								  (onstr-unformat (format-int 
													(car args) 
													filler 
													len 
													16) 
												  lst-of-chars 
												  (cdr args) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   ((#\b) 
								(if in-format
								  (onstr-unformat 
									(format-int (car args) 
												filler 
												len 
												2) 
									lst-of-chars 
									(cdr args) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   ((#\d) 
								(if in-format
								  (onstr-unformat 
									(format-int (car args) 
												filler 
												len 
												10) 
									lst-of-chars 
									(cdr args) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   ((#\c) 
								(if in-format
								  (onstr-unformat 
									(format-char (car args)) 
									lst-of-chars 
									(cdr args) acc)
								  (oncar-unformat c lst-of-chars args acc)))
							   (else
								 (if in-format
								   (raise-exception 'ERROR 'sl-printf "Bad format definition")
								   (onstr-unformat c lst-of-chars args acc)))))
						   acc))))
			  (reverse 
				(unformat lformat 
						  all-args 
						  #f 
						  (default-filler) 
						  (default-len)
						  '())))))))


	(define raw-list-to-strings
	  (lambda (ks)
		(cond
		  ((null? ks) ks)
		  (else
			(map (lambda(e)
				   (cond
					 ((null? e) "<null>")
					 ((char? e) (string e))
					 ((pair? e) "<pair>")
					 ((string? e) e)
					 (else "<bad>")))
				 ks)))))

	(define (sprintf . args)
	  (with-exception
		(try 
		  (apply string-append (raw-list-to-strings (apply ksprintf args))))
		(catch
		  "oups!!!")))

	(define slprintf 
	  (lambda all-args
		(with-exception
		  (try 
			(display (apply sprintf all-args)))
		  (catch
			"oups!!!"))))

	))
