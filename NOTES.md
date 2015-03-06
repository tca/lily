# Procedure calls

When calling a function you are setting a label to jump to, setting up args, then entering.

Arguments will be passed on the stack pushed in left to right order.

It would be useful to think of compiling to an IL made of labelled blocks (perhaps).

### Rough idea of compiling a tail call (subject to change)

```
(define (f x y) (f (+ x 1) (+ x y)))

could be compiled like this:

f:
;; expecting a stack frame set up with
;; rbp[x][y][return value]rsp

;; stack allocate two memory cells by increasing rsp
sub rsp, 2

f_inner:

;; compute (+ x 1) and store the result into the first scratch cell
<compute>
mov [rbp+4*3], rax

;; compute (+ x y) and store the result into the second scratch cell
<compute>
mov [rbp+4*4], rax

;; set up the stack frame for a tail call
mov rax,[rbp+4*3]
mov [rbp+4*1],rax
mov rax,[rbp+4*4]
mov [rbp+4*2],rax

jmp f_inner
```
