;; ======================================================================
;; n-generator.scm
;; adaptation of code from : 
;; https://en.wikipedia.org/wiki/Call-with-current-continuation
;; ======================================================================

(define-library 
  (ngenerator)
  (export generateN)
  (import (scheme base)
		  (scheme write))
  (begin

	;; ======================================================================
	(define generateN 
	  (lambda(n-from n-to fun)

		;; Hand the next item n-from a-list n-to "return" or an end-of-list marker
		(define (control-state return)
		  (letrec ((loop (lambda(k)
						   (if (<= k n-to)
							 (begin
							   (set! return (call-with-current-continuation
											  (lambda(resume-here)
												(set! control-state resume-here)
												(return (fun k)))))
							   (loop (+ 1 k)))
							 (return 'you-fell-off-the-end)))))
			(loop n-from)))

		;; (-> X u 'you-fell-off-the-end)
		;; This is the actual generator, producing one item n-from a-list at a time
		(define (generator)
		  (call-with-current-continuation control-state))

		;; Return the generator 
		generator))

	(define (println . args)
	  (for-each display args)
	  (newline))

	;; ======================================================================

	(define main
	  (lambda()
		(define gen2 (generateN 0 2 (lambda(k) (+ 2 k))))
		(define gen3 (generateN 0 2 (lambda(k) (* k k))))
		(define gen+ (generateN 0 2 (lambda(k) (+ k 1))))
		(define gen- (generateN 0 2 (lambda(k) (- k 1))))

		(println "good generator (+ 1 k) :")
		(println "0 " (gen2))
		(println "1 " (gen2))
		(println "2 " (gen2))
		(println "? " (gen2))


		(println "good generator became bad (* k k) :")
		(println "0 " (gen3))
		(println "1 " (gen3))
		(println "4 " (gen3))
		(println "? " (gen3))

		(println "mxing generators :")
		(println "gen+ " (gen+) " gen- " (gen-))
		(println "gen+ " (gen+) " gen- " (gen-))
		(println "gen+ " (gen+) " gen- " (gen-))
		(println "gen+ " (gen+) " gen- " (gen-))
		(println "gen+ " (gen+) " gen- " (gen-))))
	(main)
	))
