(define (main)
  (display (add 5 5))
  (newline)
  (return 111))

(define (add a b)
  (if a
      (display (add (- a 1) (+ b 1)))
      (display b))
  (return 0))
