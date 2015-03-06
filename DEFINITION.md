```
<program> ::= <definition> ...

<definition> ::= (define (<name> <var> ...) <statement> ... <expression>)

<statement> ::= (begin <statement> ...)
              | (print "string")
              | (print <expression>)
              | (if <expression> <statement> <statement>)
              | (set! <var> <expression>)

<expresson> ::= <var>
              | (<op> <expresson> <expresson>)
              | (<name> <expression> ...) ;; procedure call

<op> ::= + | - | * | % | / | =
```
