(define (main)
    (return (fizzbuzz 0)))

(define (fizz) (display "fizz"))

(define (buzz) (display "buzz"))

(define (fizzbuzz x)
    (if (= x 100)
        (return 0)
        (begin
            (if (= (% x 3) 0)
                (call (fizz))
                (if (= (% x 5) 0)
                    (call (buzz))
                    (if (= (% x 15) 0)
                        (begin (call (fizz)) (call (buzz)))
                        (display x))))
            (newline)
            (return (fizzbuzz (+ x 1))))))
