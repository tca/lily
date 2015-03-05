(define (fact-acc n acc)
  (if (= 0 n)
      acc
      (fact-acc (- n 1) (* acc n))))

(define (fact n)
  (fact-acc n 1))

(fact 10)
