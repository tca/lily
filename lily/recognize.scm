
(define (all p l)
  (if (null? l)
      #t
      (and (p (car l))
           (all p (cdr l)))))



(define (parse-program program)
  (let ((names (append '((= . 2)
                         (+ . 2)
                         (- . 2)
                         (* . 2)
                         (/ . 2)
                         (% . 2))
                       (extract-names program))))
    (match program
      ('() #t)
      (`(,def . ,programs)
       (and (parse-definition names def)
            (parse-program programs)))
      (else (error "not a list of definitions: " program) #f))))

(define (extract-names program)
  (map extract-name program))

(define (extract-name def)
  (match def
    (`(define (,name . ,vars) . ,body)
     (cons name (length vars)))
    (error "not a definition in extract name")))

(define (parse-definition names def)
  (match def
    (`(define (,name . ,vars) . ,body)
     (and (symbol? name)
          (all symbol? vars)
          (parse-body names body)))
    (else (error "could not parse definition: " def) #f)))

(define (parse-body names body)
  (match body
    ('() #f)
    (`(,exp) (parse-expression names exp))
    (`(,car . ,cdr)
     (and (parse-statement names car)
          (parse-body names cdr)))
    (else (error "could not parse body of: " body))))

(define (parse-statement names st)
  (match st
    (`(begin . ,ss)
     (or (all (lambda (exp) (parse-statement names exp))
              ss)
         (error "begin didn't contain all statements: " st)))
    (`(newline)
     #t)
    (`(display ,p)
     (if (string? p)
         #t
         (parse-expression names p)))
    (`(if ,t ,cs ,as)
     (and (parse-expression names t)
          (parse-statement names cs)
          (parse-statement names as)))
    (`(set! ,v ,e)
     (and (symbol? v)
          (parse-expression names e)))
    (else (error "Could not parse statement: " st))))

(define (parse-expression names exp)
  (match exp
    (else
     (or (symbol? exp)
         (number? exp)
         (and (list? exp)
              (symbol? (car exp))
              (cond ((assoc (car exp) names)
                     => (lambda (entry)
                          (= (length (cdr exp)) (cdr entry))))
                    (else #f))
              (all (lambda (exp) (parse-expression names exp)) (cdr exp)))
         (error "Not a valid expression: " exp)))))
