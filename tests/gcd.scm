(define (gcd u v)
  (if (= v 0)
      u
      (gcd v (mod u v))))

(gcd 24 36)
