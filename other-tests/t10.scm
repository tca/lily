(define (main)
  (display (testif 0 2 3))
  (display (testif 1 2 3))
  (newline)
  (return 110))

(define (testif a b c)
  (if a
      (display b)
      (display c))
  (return 0))
