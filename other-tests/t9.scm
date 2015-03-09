(define (main)
  (display (sum (x) (y)))
  (newline)
  109)

(define (x) 400)
(define (y) 7)
(define (sum a b) (+ a b))

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
