(define (compile-program program)
  (sequence->list (compile-program->seq program)))

(define (compile-program->seq program)
  (match program
    ('() 'epsilon)
    (`(,def . ,programs)
     `(join ,(compile-definition def)
            ,(compile-program->seq programs)))))

(define (compile-definition def)
  (match def
    (`(define (,name . ,vars) . ,body)
     `(join (elt (label ,name))
            ,(compile-body body)
            (elt (ret))))))

(define (compile-body body)
  (match body
    (`(,exp)
     (compile-expression exp))
    (`(,car . ,cdr)
     (join (compile-statement car)
           (compile-body cdr)))))

(define (compile-statement st)
  (match st
    (`(begin . ,ss)
     `(join . (map (lambda (exp)
                     (compile-statement exp))
                   ss)))
    (`(print ,p)
     (error "not impemented print"))
    (`(if ,t ,cs ,as)
     ;; (and (compile-expression t)
     ;;      (compile-statement cs)
     ;;      (compile-statement ss))
     (error "fail2")
     )
    (`(set! ,v ,e)
     ;; (and (symbol? v)
     ;;      (compile-expression e))
     (error "fail3"))))

(define (compile-expression exp)
  (match exp
    (`(,f . ,args)
     (begin ;; TODO fix match so I don't need this begin
       `(join
         (elt (push rbp))
         (elt (mov rbp rsp))
         (join . ,(map (lambda (arg)
                         `(join ,(compile-expression exp)
                                (push rax)))
                       args))
         (elt (call ,(mangle-name f)))
         (elt (add rsp ,(* 8 (length args))))
         (elt (pop rbp)))))
    (else (cond ((number? exp)
                 `(elt (mov rax ,exp)))
                ((symbol? exp)
                 (error "fail9"))
                (else
                 (error "fail10"))))))

(define (mangle-name f)
  (case f
    ((+) 'plus)
    (else f)))
