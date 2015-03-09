```
<program> ::= <definition> ...

<definition> ::= (define (<name> <var> ...) <statement> ... <expression>)

<statement> ::= (begin <statement> ...)
              | (display "string")
              | (display <expression>)
              | (if <expression> <statement> <statement>)
              | (set! <var> <expression>)

<expresson> ::= <var>
              | (<op> <expresson> <expresson>)
              | (<name> <expression> ...) ;; procedure call

<op> ::= + | - | * | % | / | =
```
