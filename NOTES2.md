# 1. Stack

The idea is that each procedure has its own stack frame.

If f calls g which calls h then we'll have a stack like this:

```
[f frame][g frame]|[h frame]|
                  rbp       rsp
```

# 2. Stack frame

What is in a stack frame?

* It has to store the arguments of the called procedure
* It needs to be able to allocate scratch stack space to do some work in**
* It needs to store the return address so we know where to return to once the function completes
* After returning the caller will need to restore rbp, so that is saved in the stack too.

(** if we just go with pure procedure calls then we don't need any scratch space for temporaries)

Example of 'scratch space':

```
int f(int a) {
    int u, v;
    
    u = g(a);
    v = g(a*3);
    
    return u + v;
}
```

f needs scratch space to hold two integers during its computation so it's stack frame is given two extra words after all the really important stuff (like return address, args, etc.).

this is only if we have let in the language though?

Even without let, just arithmetic, sometimes you'll need scratch space (especially when we don't have a good register allocator)

but if you do it uniformially no arguments are in registers, they are always in stack, and we can optimize primitives later on

if you treat + the same as any other call, there is no scratch space, its a real actual frame of it's own

e.g. in (f (a) (b) (c))

when (a) is evaluating, it just pushes value reg on after,
once (c) is done, you push rbp and return
thats when it becomes a real frame
the rbp for each a,b,c call is the old rbp + 1,2,3
```
v <- (a)
push v
v <- (b)
push v
v <- (c)
push v
push rbp
push return
jmp f
```


# 3. Calling convention

**Update**: It turns out this calling convention is bad! It makes it very hard to get function parameters. The C calling convention puts all the rbp work in the CALLEE instead of CALLER and this works much better. See NOTES3.md. (also if you think about it, procedures will usually call more than one procedure - so it's better to put the most work in the callee rather than the caller)

## Caller

To perform a call like (foo arg1 arg2) we could do this:

```
-CALLER-ENTER--------------------------------------------
push rbp
mov rbp,rsp
<compute arg1>
push rax
<compute arg2>
push rax
call foo ;; note that call also pushes the return address
---------------------------------------------------------
```

so foo's stack frame is set up like this:

```
|[saved rbp][arg1][arg2][return address]|
rbp                                     rsp
```

after the callee returns the return address will have been
popped off the stack, so we need clear away the arguments
and restore rbp.

```
-CALLER-RETURN-------------------------------------------
add rsp,2*8  ;; assuming 8 bytes per word
pop rbp
---------------------------------------------------------
```

# Callee

The callee does not have to do much:

```
-CALLEE-ENTER--------------------------------------------
---------------------------------------------------------
```

```
-CALLEE-RETURN-------------------------------------------
ret
---------------------------------------------------------
```

# 4. Tail calls

The idea of a tail call is to save stack space by, instead
of creating a new stack frame - overwriting the current one
with a new one and jumping.

If we have a stack frame like this:

```
|[saved rbp][me arg1][me arg2][arg3][return address]|
rbp                                                  rsp
```

we may need to make it smaller (moving return address back)

```
|[saved rbp][them arg1][them arg2][return address]|
rbp                                               rsp
````

or larger (moving return address forward).

