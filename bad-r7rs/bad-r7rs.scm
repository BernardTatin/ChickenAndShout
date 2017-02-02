;; ======================================================================
;; bad-r7rs.scm
;; Read r7rs sources files and interpret them
;; written with r5rs and some extensions
;; for guile 2.0.xx
;;	guile		: OK		(guile -s bad-r7rs.scm ../hexdump/hexdump.scm)
;;  sagittarius : OK		(sagittarius bad-r7rs.scm  ../hexdump/hexdump.scm)
;;	chicken		: OK		(csi -b  -R r7rs -s bad-r7rs.scm  ../hexdump/hexdump.scm)

;;  gosh		: FAIL      (gosh -r 7 -I . ./bad-r7rs.scm, can't find match)
;;	foment		: FAIL		(foment bad-r7rs.scm syntax-violation variable "variable: bound to syntax" irritants: (...))
;;  gambit      : FAIL		(ggsi bad-r7rs.scm, Unbound variable: scheme)
;; ======================================================================

(cond-expand
  (guile 
	(use-modules (ice-9 match)))
  (gosh
	(import (scheme base) (scheme write) (scheme read) (scheme file) (scheme process-context) (util match)))
  (sagittarius
	(import (scheme base) (scheme write) (scheme read) (scheme file) (scheme process-context) (match)))
  (chicken
	(import (scheme base) (scheme write) (scheme read) (scheme file) (scheme process-context) (matchable) (extras)))
  (else
	(import (scheme base) (scheme write) (scheme read) 
			(scheme process-context) 
			)))

(define (println . args)
  (for-each display args))

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


(define dohelp
  (lambda(exe-name exit-code)
	(println exe-name " [-h|--help] : this text\n")
	(println exe-name " file [file ...] : lint all the files\n")
	(exit exit-code)))

(define on-file
  (lambda (file-name)
	(let ((p (read-file file-name)))
	  (for-each 
		(lambda(e) (println "-->" (lint-r7rs e) "<--\n")) 
		p))))

(define themain
  (lambda (args)
	(let ((exe-name (car args))
		  (_args (cdr args)))
	  (match _args
			 (() (dohelp exe-name 0))
			 (("-h") (dohelp exe-name 0))
			 (("-h" _ ...) (dohelp exe-name 0))
			 (("--help") (dohelp exe-name 0))
			 (("--help" _ ...) (dohelp exe-name 0))
			 (else 
			   (for-each on-file _args)
			   (exit 0))))))

(themain (command-line))
