(define (main)
  (display (sum (a (b (c))) (b (c)) (c)))
  (newline)
  108)

(define (a x)
  (+ x 100))

(define (b y)
  (+ y 20))

(define (c)
  3)

(define (sum a b c)
  (+ a (+ b c)))
