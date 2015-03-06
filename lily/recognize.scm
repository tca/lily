
(define (all p l)
  (if (null? l)
      #t
      (and (p (car l))
           (all p (cdr l)))))

;; TODO: extract names of all the definitions
;; pass this list in for procedure calls to
;; check against (e.g. right now if inside an
;; expression is accepted

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
    (`(begin . ,ss)
     (all (parse-statement ss)))
    (`(print ,p)
     (if (string? p)
         #t
         (parse-expression p)))
    (`(if ,t ,cs ,as)
     (and (parse-expression t)
          (parse-statement cs)
          (parse-statement ss)))
    (`(set! ,v ,e)
     (and (symbol? v)
          (parse-expression e)))
    (else #f)))

(define (parse-expression exp)
  (match exp
    (else
     (or (symbol? exp)
         (number? exp)
         (and (list? exp)
              (symbol? (car exp))
              (all parse-expression (cdr exp)))))))
