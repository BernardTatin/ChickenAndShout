;; ======================================================================
;; bad-r7rs.scm
;; Read r7rs sources files and interpret them
;; written with r5rs and some extensions
;; ======================================================================

(define read-file
  (lambda(file-name)
	(let ((handle (open-input-file file-name)))
	  (letrec ((rloop (lambda()
						(let ((expression (read handle)))
						  (if (eof-object? expression)
							#t
							(begin
							  (display expression)
							  (newline)
							  (rloop)
							  ))
						  )
						)))
		(rloop)
		(close-input-port handle)))))

(read-file "../hexdump/hexdump.scm")
