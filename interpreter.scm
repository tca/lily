(map load '("../match-sagittarius/trie.sld" "../match-sagittarius/compile-pattern.sld" "../match-sagittarius/interpret-tree.sld" "../match-sagittarius/match.sld"))
(import (match)
        (pp)
        (core errors))

(define (collect-define exp defines)
  (match exp
    (`(define (,name . ,_) . ,_) (cons name defines))
    (else defines)))

(define (collect-defines exps)
  (fold-left (lambda (ds e) (collect-define e ds)) '() exps))

(define (desugar exp env)
  (cond
   ((symbol? exp) exp)
   ((number? exp) exp)
   ((pair? exp)
    (if (member (car exp) env)
        (map (lambda (e) (desugar e env)) exp)
        (match exp
          (`(if ,t ,c ,a) `(if ,(desugar t env) ,(desugar c env) ,(desugar a env)))
          (`(begin . ,body) `(begin . ,(map (lambda (e) (desugar e env)) body)))
          (`(define ,bindings . ,body) `(define ,bindings ,(desugar `(begin . ,body) env)))
          (else (error "unkown exp: " exp)))))
   (else (error "unkown exp: " exp))))

(define (fold-app fn exps e te k)
  ((fold-right (lambda (c m) (lambda (s) (eval c e te (lambda (x) (m (cons x s))))))
               (lambda (args) (fn k (reverse args)))
               exps)
   '()))

(define (eval c e te k)
  (cond
   ((symbol? c) (cond
                  ((assoc c e) => (lambda (p) (k (cdr p))))
                  (else (error 'eval "unbound variable: " c))))
   ((number? c) (k c))
   ((pair? c)
    (cond
     ((assoc (car c) te) => (lambda (p) (fold-app (cdr p) (cdr c) e te k)))
     (else (match c
             (`(if ,t ,c ,a) (let* ((passk (lambda (r) (eval c e te k)))
                                    (failk (lambda (r) (eval a e te k))))
                               (eval t e te (lambda (r) (if (= 0 r) (failk '()) (passk '()))))))
             (`(begin ,fe) (eval fe e te k))
             (`(begin ,fe . ,re) (eval fe e te (lambda (_) (eval `(begin . ,re) e te k))))
             (`(define (,name . ,params) ,body)
              (let ((compiled
                     (lambda (k args)
                       (eval body
                             (map cons params args)
                             te
                             k))))
                (set-cdr! (assoc name te) compiled)
                (k 0)))
             (else (error 'eval "unkown exp: " c))))))
   (else (error 'eval "unkown exp: " c))))

(define builtins
  `((+ . ,(lambda (k args) (k (+ (car args) (cadr args)))))
    (= . ,(lambda (k args) (k (= (car args) (cadr args)))))))

(define (run-program p)
  (let* ((defines (collect-defines p))
         (desugared (map (lambda (e) (desugar e (append defines (map car builtins)))) p)))
    (eval `(begin . ,desugared) '() (append (map list defines) builtins) (lambda (x) x))))

#|
(pretty-print (eval 1 '() '() (lambda (x) x)))
(pretty-print (eval 'a '((a . 1)) '()  (lambda (x) x)))
(pretty-print (eval '(if 1 2 3) '() '() (lambda (x) x)))
(pretty-print (eval '(if 0 2 3) '() '() (lambda (x) x)))
(pretty-print (eval '(begin 1 2 3) '() '() (lambda (x) x)))
(pretty-print (run-program '((define (a) 1) (define (b) 2) (+ (a) (b)))))
|#
