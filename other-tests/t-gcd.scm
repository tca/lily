(define (main)
  (display (gcd 324 22))
  (newline)

  (display (gcd 3214 22324))
  (newline)

  (display (gcd 2334 142241))
  (newline)

  (display (gcd 3654 3645))
  (newline)

  (display (gcd 1010101 1111))
  (newline))

(define (gcd x y)
  (if (= 0 x)
      (return y)
      (if (<= x y)
          (return (gcd x (- y x)))
          (return (gcd y x)))))
