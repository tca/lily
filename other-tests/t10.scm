(define (main)
  (display (testif 0 2 3))
  (display (testif 1 2 3))
  (newline)
  110)

(define (testif a b c)
  (if a
      (display b)
      (display c))
  0)
