(import (match match)
        (pp)
        (srfi :111)
        (core errors)
        (util file))

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
   ((number? c) (lambda (k args) (k c)))
   ((pair? c)
    (cond
     ((assoc (car c) te) =>
      (lambda (p)
        (let* ((fn (cdr p))
               (fn (if (box? fn) (lambda (k args) ((unbox fn) k args)) fn))
               (ct-args (cdr c))
               (len (length ct-args))
               (ct-frame (map (lambda (c) (eval c e te)) ct-args)))
          (lambda (k args)
            (let ((frame (make-vector len)))
              (let build-frame ((args1 ct-frame) (n 0))
                (if (null? args1)
                    (fn k frame)
                    (let ((setter (lambda (x)
                                    (vector-set! frame n x)
                                    (build-frame (cdr args1) (+ n 1)))))
                      ((car args1) setter args)))))))))
     (else (match c
            (`(if ,t ,c ,a)
             (let ((t1 (eval t e te))
                   (c1 (eval c e te))
                   (a1 (eval a e te)))
                 (lambda (k args)
                   (t1 (lambda (x) (if (zero? x) (a1 k args) (c1 k args))) args))))
            (`(begin ,fe) (eval fe e te))
            (`(begin ,fe . ,re)
             (let ((e1e (eval fe e te))
                   (e2e (eval `(begin . ,re) e te)))
               (lambda (k args) (e1e (lambda (_) (e2e k args)) args))))
            (else (error 'eval "unkown exp: " c))))))
  (else (error 'eval "unkown exp: " c))))

(define (build-call-env params)
  (map (lambda (p) (cons p (lambda (c) (lambda (k args) (k (vector-ref args c)))))) params))

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
  `((= . ,(lambda (k args) (k (if (= (vector-ref args 0) (vector-ref args 1)) 1 0))))
    (+ . ,(lambda (k args) (k (+ (vector-ref args 0) (vector-ref args 1)))))
    (- . ,(lambda (k args) (k (- (vector-ref args 0) (vector-ref args 1)))))
    (* . ,(lambda (k args) (k (* (vector-ref args 0) (vector-ref args 1)))))
    (/ . ,(lambda (k args) (k (/ (vector-ref args 0) (vector-ref args 1)))))
    (mod . ,(lambda (k args) (k (mod (vector-ref args 0) (vector-ref args 1)))))))

(define (run-program p)
  (let* ((defines (collect-defines p)))
    (eval-program p '() (append (map (lambda (d) (cons d (box '()))) defines) builtins))))

(let ((args (command-line)))
  ((run-program (file->sexp-list (cadr args)))
   (lambda (x)
     (newline)
     (display x)
     (newline))
   #()))
