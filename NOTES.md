# Procedure calls

When calling a function you are setting a label to jump to, setting up args, then entering.

Arguments will be passed on the stack pushed in left to right order.

It would be useful to think of compiling to an IL made of labelled blocks (perhaps).

procedure calls ddont play well with register allocation so optimize `(+ x y (g) z w)` to `(set! tmp-1 (g))  (+ x y tmp-1 z w)`.

### Rough idea of compiling a tail call (subject to change)

```
(define (f x y) (f (+ x 1) (+ x y)))

could be compiled like this:

f:
;; expecting a stack frame set up with
;; rbp[saved rbp][return address][x][y]rsp

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

### Rough idea for the stack frame layout/calling convention

use `rax` to return values. Use `rbp` for base pointer and `rsp` for stack.

to call a procedure foo:

```
...
;; push each arg on the stack
push rbp
call foo
pop rbp
;; return value is rax
...
```

the procedure itself:

```
foo:
mov rbp,rsp
(A)
...
(B)
...
ret
```

at time (A) the stack looks like:

```
----------------rbp
[  foo arg 1   ]
[  foo arg 2   ]
[  saved rbp   ]
[return address]
----------------rsp
```

(B) can extend rsp as much as it wants

```
----------------rbp
[  foo arg 1   ]
[  foo arg 2   ]
[  saved rbp   ]
[return address]
[scratch space ]
[scratch space ]
[scratch space ]
[scratch space ]
[scratch space ]
----------------rsp
```

(make sure to get rid of that before doing ret)
