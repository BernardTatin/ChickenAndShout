;; ======================================================================
;; bad-r7rs.scm
;; Read r7rs sources files and interpret them
;; written with r5rs and some extensions
;; for guile 2.0.xx
;;	guile		: OK		(guile bad-r7rs)
;;  gosh		: FAIL      (gosh -r 7 -I . ./bad-r7rs.scm, can't find match)
;;  sagittarius : OK		(sagittarius bad-r7rs.scm)
;;	chicken		: OK		(csi  -R r7rs bad-r7rs.scm)
;;	foment		: FAIL		(foment bad-r7rs.scm syntax-violation variable "variable: bound to syntax" irritants: (...))
;;  gambit      : FAIL		(ggsi bad-r7rs.scm, Unbound variable: scheme)
;; ======================================================================

(cond-expand
  (guile 
	(use-modules (ice-9 match)))
  (gosh
	(import (scheme base) (scheme write) (scheme read) (scheme file) (util match)))
  (sagittarius
	(import (scheme base) (scheme write) (scheme read) (scheme file) (match)))
  (chicken
	(import (scheme base) (scheme write) (scheme read) (scheme file) (matchable) (extras)))
  (else
	(import (scheme base) (scheme write) (scheme read) 
			;; (scheme file)
			)))



(define read-file
  (lambda(file-name)
	(let ((handle (open-input-file file-name)))
	  (letrec ((rloop (lambda(acc)
						(let ((expression (read handle)))
						  (if (eof-object? expression)
							(reverse acc)
							(rloop (cons expression acc)))))))
		(let ((r (rloop '())))
		  (close-input-port handle)
		  r)))))

(define show-code
  (lambda(code)
	(cond
	  ((null? code) #t)
	  ((pair? code) (display "(") (for-each show-code code) (display ")\n"))
	  (else (display " :") (display code) (display ": ")))))

(define lint-r7rs
  (lambda(code)
	(cond
	  ((null? code) #t)
	  ((pair? code)
	   (match code
			  (('define-library (library-name) rest ...)
			   (display "Library: <") (display library-name) (display ">\n")
			   (lint-r7rs rest))
			  ((('export symbols) rest ...)
			   (display "  exports <") (display symbols) (display ">\n")
			   (lint-r7rs rest))
			  ((('import symbols ...) rest ...)
			   (display "  imports <") (display symbols) (display ">\n")
			   (lint-r7rs rest))
			  ((('cond-expand conditionnals ...) rest ...)
			   (letrec ((loop (lambda(c)
								(match c
									   ('()
										(lint-r7rs rest))
									   ((('chicken more ...) others ...)
										(cond-expand
										  (chicken 
											(lint-r7rs more)
											(lint-r7rs rest))
										  (else (loop others))
										  ))
									   ((('guile more ...) others ...)
										(cond-expand
										  (guile 
											(lint-r7rs more)
											(lint-r7rs rest))
										  (else (loop others))
										  ))
									   ((('sagittarius more ...) others ...)
										(cond-expand
										  (sagittarius 
											(lint-r7rs more)
											(lint-r7rs rest))
										  (else (loop others))
										  ))
									   (('else more ...)
										(lint-r7rs more)
										(lint-r7rs rest))
									   (((compiler-name _ ...) others ...)
										(loop others))
									   (else 
										 (loop (cdr c)))))))
				 (loop conditionnals)))
			  ((('define body ...) rest ...)
			   (display "  define <") (display (car body)) (display ">\n")
			   (lint-r7rs (list (cdr body) rest)))
			  ((head rest ...)
			   (lint-r7rs head)
			   (lint-r7rs rest))))
	  (else #t))))


(let ((p (read-file "../hexdump/hexdump.scm")))
  (for-each (lambda(e)
			  (display "-->")
			  (lint-r7rs e)
			  (display "<--\n")) p))


#|
((owl-lisp (import (owl defmac) (owl io) (scheme base) (scheme write) (slprintf slprintf) (slprintf format format-int) (slprintf values) (slprintf format format-int) (tools exception) (bbmatch bbmatch) (helpers) (fileOperations binFileReader)))
 (gosh (import (scheme base) (scheme write) (util match) (slprintf slprintf) (slprintf format format-int) (slprintf values) (slprintf format format-int) (tools exception) (helpers) (fileOperations binFileReader)))
 (sagittarius (import (scheme base) (scheme write) (match) (slprintf slprintf) (slprintf format format-int) (slprintf values) (slprintf format format-int) (tools exception) (helpers) (fileOperations binFileReader)))
 (chicken (import (scheme base) (scheme write) (matchable) (slprintf slprintf) (slprintf format format-int) (slprintf values) (slprintf format format-int) (tools exception) (helpers) (fileOperations binFileReader)))
 (else (import (scheme base) (scheme write) (slprintf slprintf) (slprintf format format-int) (slprintf values) (slprintf format format-int) (tools exception) (bbmatch bbmatch) (helpers) (fileOperations binFileReader)))
 )
|#
