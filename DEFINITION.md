```
<progam> ::= <definition> ...

<definition> ::= (define (<name> <var> ...) <statement> ... <expression>)

<statement> ::= (print "string")
              | (print <expression>)

<expresson> ::= <var>
              | (<op> <expresson> <expresson>)
              | (if <expresson>  <expresson> <expresson>)
              | (<name> <expression> ...) ;; procedure call

<op> ::= + | - | * | % | / | =
```
