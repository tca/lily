```
<program> ::= <definition> ...

<definition> ::= (define (<name> <var> ...) <statement> ...)

<statement> ::= (begin <statement> ...)
              | (display "string")
              | (display <expression>)
              | (if <expression> <statement> <statement>)
              | (set! <var> <expression>)
              | (return <expression>)

<expresson> ::= <var>
              | (<op> <expresson> <expresson>)
              | (<name> <expression> ...) ;; procedure call

<op> ::= + | - | * | % | / | =
```

Note: If a program has no return statement it will just return 0.
