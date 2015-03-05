(define (print x) (write x) (newline))


(define (compile-program program)
  (map compile-definition program))

(define (compile-definition def)
  (match def
    (`(define (,name . ,arg-names) . ,body)
     (begin
       (list name (length arg-names)
             (lambda (program args)
               (let ((env (map cons arg-names args)))
                 (execute-body program env body))))))))

(define (lookup-in-env exp env)
  (cond ((assoc exp env) => cdr)
        (else (error "not in there!"))))

(define (execute-body program env body)
  (match body
    (`(,exp) (execute-expression program env exp))
    (`(,car . ,cdr)
     (and (execute-statement program env car)
          (execute-body program env cdr)))))

(define (execute-statement program env st)
  (match st
    (`(print ,p)
     (print (execute-expression program env p)))))

(define (execute-expression program env exp)
  (match exp
    (`(if ,t ,c ,a)
     (if (execute-expression program env t)
         (execute-expression program env c)
         (execute-expression program env a)))
    (else
     (cond ((number? exp) exp)
           ((symbol? exp) (lookup-in-env exp env))
           ((and (list? exp)
                 (symbol? (car exp)))
            (apply-function program (car exp)
                (map (lambda (exp)
                       (execute-expression program env exp))
                     (cdr exp))))))))

(define (apply-function program name args)
  (match (assoc name program)
    (`(,name ,expected-args ,closure)
     (if (= expected-args (length args))
         (closure program args)
         (error "Invalid number of args passed to function")))))
