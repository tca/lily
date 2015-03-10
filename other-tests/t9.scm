(define (main)
  (display (sum (x) (y)))
  (newline)
  (return 109))

(define (x) (return 400))
(define (y) (return 7))
(define (sum a b) (return (+ a b)))

#| ;;;;;;;;;

enter main:

[saved rbp]||
         rbp rsp

call x:

[saved rbp]|[return address]|
         rbp                rsp

[saved rbp]|[return address][saved rbp]|
         rbp                           rsp

[saved rbp][return address][saved rbp]||
                                   rbp rsp

set rax

pop rbp

[saved rbp]|[return address]|
         rbp                rsp

ret

[saved rbp]||
         rbprsp

now we're back in main
push rax

[saved rbp]|[    400]|
         rbp        rsp

call y

[saved rbp]|[    400]|
         rbp        rsp

[saved rbp]|[    400][saved rbp]|
         rbp                    rsp



;;;;;;;;; |#
