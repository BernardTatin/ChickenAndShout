;; ======================================================================
;; one-element-at-a-time.scm
;; code from : https://en.wikipedia.org/wiki/Call-with-current-continuation
;; ======================================================================

;; utility
	(define (println . args)
	  (for-each display args)
	  (newline))

;; ======================================================================
;; [LISTOF X] -> ( -> X u 'you-fell-off-the-end)
(define (generate-one-element-at-a-time lst)

  ;; Hand the next item from a-list to "return" or an end-of-list marker
  (define (control-state return)
	(for-each 
	  (lambda (element)
		(set! return (call-with-current-continuation
					   (lambda (resume-here)
						 ;; Grab the current continuation
						 (set! control-state resume-here)
						 (return element)))))
	  lst)
	(return 'you-fell-off-the-end))

  ;; (-> X u 'you-fell-off-the-end)
  ;; This is the actual generator, producing one item from a-list at a time
  (define (generator)
	(call-with-current-continuation control-state))

  ;; Return the generator 
  generator)


;; ======================================================================
;; first test
;; ======================================================================
(define generate-digit
  (generate-one-element-at-a-time '(0 1 2)))

(println (generate-digit)) ;; 0
(println (generate-digit)) ;; 1
(println (generate-digit)) ;; 2
(println (generate-digit)) ;; 'you-fell-off-the-end

;; ======================================================================
;; second test
;; ======================================================================
(define generate-symbol
  (generate-one-element-at-a-time '(a b (c1 c2) d)))

(println (generate-symbol)) ;; a
(println (generate-symbol)) ;; b
(println (generate-symbol)) ;; (c1 c2)
(println (generate-symbol)) ;; d
(println (generate-symbol)) ;; 'you-fell-off-the-end
(println (generate-symbol)) ;; 'you-fell-off-the-end
