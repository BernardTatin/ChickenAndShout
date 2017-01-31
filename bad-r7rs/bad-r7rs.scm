;; ======================================================================
;; bad-r7rs.scm
;; Read r7rs sources files and interpret them
;; written with r5rs and some extensions
;; for guile 2.0.xx
;; ======================================================================

(use-modules (ice-9 match))

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
	   ;; (display "----- pair? ") (display code) (display "\n")
	   (match code
			  (('define-library (library-name) rest ...)
			   (display "Library: <") (display library-name) (display ">\n")
			   (lint-r7rs rest))
			  ((('export symbols) rest ...)
			   (display "  exports <") (display symbols) (display ">\n")
			   (lint-r7rs rest))
			  ((head rest ...)
			   (lint-r7rs rest))))
	  (else #t))))


(let ((p (read-file "../hexdump/hexdump.scm")))
  (for-each (lambda(e)
			  (display "-->")
			  (lint-r7rs e)
			  (display "<--\n")) p))
