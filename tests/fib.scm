(define (fib-aux m k c)
  (if (= c 0)
      m
      (fib-aux k (+ m k) (- c 1))))

(define (fib n)
  (fib-aux 0 1 n))
