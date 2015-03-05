(define (gcd u v)
  (if (= v 0)
      u
      (gcd v (mod u v))))
