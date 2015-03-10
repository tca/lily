(define (main)
  (display (add 5 5))
  (newline)
  111)

(define (add a b)
  (if a
      (display b)
      (display (add (- a 1) (+ b 1))))
  0)
