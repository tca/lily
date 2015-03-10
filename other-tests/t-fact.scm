(define (main)
  (display (fact 4)) (newline)
  (display (fact 5)) (newline)
  (display (fact 6)) (newline)
  (display (fact 7)) (newline)
  (return 0))

(define (fact n)
  (if (= 0 n)
      (return 1)
      (return (* n (fact (- n 1))))))

