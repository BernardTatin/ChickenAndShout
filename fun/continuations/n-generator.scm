;; ======================================================================
;; n-generator.scm
;; adaptation of code from : 
;; https://en.wikipedia.org/wiki/Call-with-current-continuation
;; ======================================================================

;; utility
(define (println . args)
  (for-each display args)
  (newline))

;; ======================================================================
(define (bad-generate-N from to)

  ;; Hand the next item from a-list to "return" or an end-of-list marker
  (define (control-state return)
	(if (<= from to)
	  (set! return (call-with-current-continuation
					 (lambda(resume-here)
					   (set! control-state resume-here)
					   (return (+ 1 from)))))
	  (return 'you-fell-off-the-end)))

  ;; (-> X u 'you-fell-off-the-end)
  ;; This is the actual generator, producing one item from a-list at a time
  (define (generator)
	(call-with-current-continuation control-state))

  ;; Return the generator 
  generator)
;; ======================================================================
(define (generate-N from to fun)

  ;; Hand the next item from a-list to "return" or an end-of-list marker
  (define (control-state return)
	(letrec ((loop (lambda(k)
				  (if (<= k to)
					(begin 
					  (set! return (call-with-current-continuation
									 (lambda(resume-here)
									   (set! control-state resume-here)
									   (return (fun k)))))
					  (loop (+ 1 k)))
					(return 'you-fell-off-the-end)))))
	  (loop from)))

  ;; (-> X u 'you-fell-off-the-end)
  ;; This is the actual generator, producing one item from a-list at a time
  (define (generator)
	(call-with-current-continuation control-state))

  ;; Return the generator 
  generator)

(define gen1 (bad-generate-N 0 2))

(println "bad generator :")
(println "1 " (gen1))
(println "2 " (gen1))
(println "? " (gen1))
(println "? " (gen1))

(define gen2 (generate-N 0 2 (lambda(k) (+ 2 k))))

(println "good generator (+ 1 k) :")
(println "0 " (gen2))
(println "2 " (gen2))
(println "2 " (gen2))
(println "? " (gen2))

(define gen3 (generate-N 0 2 (lambda(k) (* k k))))

(println "good generator became bad (* k k) :")
(println "0 " (gen3))
(println "1 " (gen3))
(println "4 " (gen3))
(println "? " (gen3))

(define gen+ (generate-N 0 2 (lambda(k) (+ k 1))))
(define gen- (generate-N 0 2 (lambda(k) (- k 1))))
(println "mxing generators :")
(println "gen+ " (gen+) " gen- " (gen-))
(println "gen+ " (gen+) " gen- " (gen-))
(println "gen+ " (gen+) " gen- " (gen-))
(println "gen+ " (gen+) " gen- " (gen-))
(println "gen+ " (gen+) " gen- " (gen-))
