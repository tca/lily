(define (main) (return (go-a)))
(define (go-a) (return (go-b)))
(define (go-b) (return (go-c)))
(define (go-c) (return 103))
