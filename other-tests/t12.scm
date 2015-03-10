(define (main)
  (if 0
      (display 111)
      (display 222))
  (if 1
      (display 111)
      (display 222))
  (newline)
  (display (goo 0 0))
  (display (goo 0 1))
  (display (goo 1 0))
  (display (goo 1 1))
  0)

(define (goo x y)
  (if x
      (if y
          (display 111333)
          (display 111666))
      (if y
          (display 222333)
          (display 222666)))
  (newline)
  0)

