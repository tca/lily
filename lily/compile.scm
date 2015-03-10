(define (compile-program program)
  (sequence->list `(join (elt (include "base.asm"))
                         ,(compile-program->seq program))))

(define (compile-program->seq program)
  (match program
    ('() 'epsilon)
    (`(,def . ,programs)
     `(join ,(compile-definition def)
            ,(compile-program->seq programs)))))

(define (compile-definition def)
  (match def
    (`(define (,name . ,vars) . ,body)
     `(join (elt (label ,(mangle-symbol name)))
            (elt (push rbp))
            (elt (mov rbp rsp))
            ,(compile-body vars body)
            (elt (pop rbp))
            (elt (ret))))
    (else (error "bad define" def))))

(define (compile-body vars body)
  (match body
    (`(,exp) (compile-expression vars exp))
    (`(,car . ,cdr)
     `(join ,(compile-statement vars car)
            ,(compile-body vars cdr)))
    (else (error "bad body" body))))

(define (compile-statement vars st)
  (match st
    (`(begin . ,ss)
     `(join . (map (lambda (exp)
                     (compile-statement vars exp))
                   ss)))
    (`(newline)
     `(elt (call newline)))
    (`(display ,p)
     `(join ,(compile-expression vars p)
            (elt (call display))))
    (`(if ,t ,cs ,as)
     (let ((fail-label (mangle-symbol (gensym ".fail"))))
       `(join ,(compile-expression vars t)
              (elt (test rax rax))
              (elt (jz ,fail-label))
              ,(compile-statement vars cs)
              (elt (label ,fail-label))
              ,(compile-statement vars as))))
    (`(set! ,v ,e)
     ;; (and (symbol? v)
     ;;      (compile-expression e))
     (error "fail3"))
    (else (error "unkown statement:" st))))

(define (compile-expression vars exp)
  (match exp
    (`(,f . ,args)
     (begin ;; TODO fix match so I don't need this begin
       `(join
         (join . ,(map (lambda (arg)
                         `(join ,(compile-expression vars arg)
                                (elt (push rax))))
                       args))
         (elt (call ,(mangle-name f)))
         (elt (add rsp ,(* 8 (length args)))))))
    (else (cond ((number? exp)
                 `(elt (mov rax ,exp)))
                ((symbol? exp)
                 `(elt (mov rax (+ rbp ,(offset-of exp vars)))))
                (else
                 (error "fail10"))))))

(define (offset-of var list)
  (* 8 (+ (- (length list) (index-of var list))
          1)))

(define (index-of var list)
  (if (eq? var (car list))
      0
      (+ 1 (index-of var (cdr list)))))

(define (mangle-name f)
  (case f
    ((=) 'equal)
    ((-) 'minus)
    ((+) 'plus)
    (else (mangle-symbol f))))
