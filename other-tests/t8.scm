(define (main)
  (display (sum (a (b (c))) (b (c)) (c)))
  (newline)
  (return 108))

(define (a x)
  (return (+ x 100)))

(define (b y)
  (return (+ y 20)))

(define (c)
  (return 3))

(define (sum a b c)
  (return (+ a (+ b c))))
