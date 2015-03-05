
(define (all p l)
  (if (null? l)
      #t
      (and (p (car l))
           (all p (cdr l)))))


(define (parse-program program)
  (match program
    ('() #t)
    (`(,def . ,programs)
     (and (parse-definition def)
          (parse-program programs)))
    (else #f)))

(define (parse-definition def)
  (match def
    (`(define (,name . ,vars) . ,body)
     (and (symbol? name)
          (all symbol? vars)
          (parse-body body)))
    (else #f)))

(define (parse-body body)
  (match body
    ('() #f)
    (`(,exp) (parse-expression exp))
    (`(,car . ,cdr)
     (and (parse-statement car)
          (parse-body cdr)))
    (else #f)))

(define (parse-statement st)
  (match st
    (`(print ,p)
     (if (string? p)
         #t
         (parse-expression p)))
    (else #f)))

(define (parse-expression exp)
  (match exp
    (`(if ,t ,c ,a)
     (and (parse-expression t)
          (parse-expression c)
          (parse-expression a)))
    (else
     (or (symbol? exp)
         (number? exp)
         (and (list? exp)
              (symbol? (car exp))
              (all parse-expression (cdr exp)))))))
