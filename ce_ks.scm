(import (match match)
        (pp)
        (srfi :111)
        (core errors)
        (util file))

(define (stack-ref sc n)
  (vector-ref (stack sc) (+ (base-pointer sc) n)))
(define (stack-cursor stack bp sp)
  (list stack bp sp))
(define (stack frame) (car frame))
(define (base-pointer frame) (cadr frame))
(define (stack-pointer frame) (caddr frame))

(define (collect-define exp defines)
  (match exp
    (`(define (,name . ,_) . ,_) (cons name defines))
    (else defines)))

(define (collect-defines exps)
  (fold-left (lambda (ds e) (collect-define e ds)) '() exps))

(define (lookup-calc a env n)
  (cond ((null? env) #f)
        ((equal? (caar env) a) (cons n (cdar env)))
        (else (lookup-calc a (cdr env) (+ n 1)))))

(define (eval c e te)
  (cond
   ((symbol? c) (cond
                 ((lookup-calc c e 0) => (lambda (p) ((cdr p) (car p))))
                 (else (error 'eval "unbound variable: " c))))
   ((number? c) (lambda (k sc) (k c)))
   ((pair? c)
    (cond
     ((assoc (car c) te) =>
      (lambda (p)
        (let* ((fn (cdr p))
               (fn (if (box? fn) (lambda (k sc) ((unbox fn) k sc)) fn))
               (ct-args (cdr c))
               (len (length ct-args))
               (ct-frame (map (lambda (c) (eval c e te)) ct-args)))
          (lambda (k sc)
            (let ((stack (stack sc))
                  (bp (base-pointer sc))
                  (sp (stack-pointer sc)))
              (let build-frame ((ct-frame^ ct-frame) (sp^ sp))
                (if (null? ct-frame^)
                    (fn k (stack-cursor stack sp sp^))
                    (let ((setter (lambda (x)
                                    (vector-set! stack sp^ x)
                                    (build-frame (cdr ct-frame^) (+ sp^ 1)))))
                      ((car ct-frame^) setter sc)))))))))
     (else (match c
            (`(if ,t ,c ,a)
             (let ((t1 (eval t e te))
                   (c1 (eval c e te))
                   (a1 (eval a e te)))
                 (lambda (k sc)
                   (t1 (lambda (x) (if (zero? x) (a1 k sc) (c1 k sc))) sc))))
            (`(begin ,fe) (eval fe e te))
            (`(begin ,fe . ,re)
             (let ((e1e (eval fe e te))
                   (e2e (eval `(begin . ,re) e te)))
               (lambda (k sc) (e1e (lambda (_) (e2e k sc)) sc))))
            (else (error 'eval "unkown exp: " c))))))
  (else (error 'eval "unkown exp: " c))))

(define (build-call-env params)
  (map (lambda (p) (cons p (lambda (c) (lambda (k sc) (k (stack-ref sc c)))))) params))

(define (eval-top c e te)
  (match c
    (`(define (,name . ,params) . ,body)
     (let* ((e1 (build-call-env params))
            (compiled (eval `(begin . ,body) e1 te)))
       (set-box! (cdr (assoc name te)) compiled)))
    (else (eval c e te))))

(define (eval-program p e te)
  (match p
    (`() (error 'eval-top "empty program"))
    (`(,fe) (eval-top fe e te))
    (`(,fe . ,re) (begin (eval-top fe e te) (eval-program re e te)))))

(define builtins
  `((= . ,(lambda (k sc) (k (if (= (stack-ref sc 0) (stack-ref sc 1)) 1 0))))
    (+ . ,(lambda (k sc) (k (+ (stack-ref sc 0) (stack-ref sc 1)))))
    (- . ,(lambda (k sc) (k (- (stack-ref sc 0) (stack-ref sc 1)))))
    (* . ,(lambda (k sc) (k (* (stack-ref sc 0) (stack-ref sc 1)))))
    (/ . ,(lambda (k sc) (k (/ (stack-ref sc 0) (stack-ref sc 1)))))
    (mod . ,(lambda (k sc) (k (mod (stack-ref sc 0) (stack-ref sc 1)))))))

(define (run-program p)
  (let* ((defines (collect-defines p)))
    (eval-program p '() (append (map (lambda (d) (cons d (box '()))) defines) builtins))))

(let ((args (command-line)))
  ((run-program (file->sexp-list (cadr args)))
   (lambda (x)
     (newline)
     (display x)
     (newline))
   (stack-cursor (make-vector 2000001) 0 0)))
