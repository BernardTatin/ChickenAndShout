;; ======================================================================
;; helpers.scm
;; date		: 2016-03-18 22:03
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

;; (declare (unit helpers))

(define-library 
  (helpers)
  (export dohelp doversion)
  (import (scheme base) (scheme write) (scheme process-context))

  (begin
	(define *app-name* (car (command-line)))
	(define *app-vers* "0.0.1")

	(define dohelp
	  (lambda (exit-code)
		(printf "~A [--help] : this text and exits~%" *app-name*)
		(printf "~A --version : show the version and exits~%" *app-name*)
		(printf "~A file file ... : make an hexdump of all these files~%" *app-name*)
		(exit exit-code)))

	(define doversion
	  (lambda (exit-code)
		(printf "~A version ~A~%" *app-name* *app-vers*)
		(printf "   (more informations with : ~A --help)~%" *app-name*)
		(exit exit-code)))
	))
