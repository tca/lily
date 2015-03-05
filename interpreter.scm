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

(define (eval c e te k)
  (cond
   ((symbol? c) (cond
                 ((assoc c e) => (lambda (p) (k (cdr p))))
                 (else (error 'eval "unbound variable: " c))))
   ((number? c) (k c))
   ((pair? c)
    (cond
     ((assoc (car c) te) =>
      (lambda (p)
        (let ((fn (unbox (cdr p)))
              (args (cdr c)))
          ((fold-left (lambda (k c) (eval c e te (lambda (x) (lambda (s) (k (cons x s))))))
                      (lambda (frame) (fn k frame))
                      args) '()))))
     (else (match c
             (`(if ,t ,c ,a)
              (eval t e te (lambda (t1) (if (zero? t1) (eval a e te k) (eval c e te k)))))
             (`(begin ,fe) (eval fe e te k))
             (`(begin ,fe . ,re) (eval fe e te (lambda (_) (eval `(begin . ,re) e te k))))
             (else (error 'eval "unkown exp: " c))))))
   (else (error 'eval "unkown exp: " c))))

(define (eval-top c e te k)
  (match c
    (`(define (,name . ,params) . ,body)
     (let ((compiled (lambda (k args) (eval `(begin . ,body) (map cons params args) te k))))
       (set-box! (cdr (assoc name te)) compiled)
       (k 0)))
    (else (eval c e te k))))

(define (eval-program p e te k)
  (match p
    (`() (error 'eval-top "empty program"))
    (`(,fe) (eval-top fe e te k))
    (`(,fe . ,re) (eval-top fe e te (lambda (_) (eval-program re e te k))))))

(define builtins
  `((= . ,(lambda (k args) (k (if (= (car args) (cadr args)) 1 0))))
    (+ . ,(lambda (k args) (k (+ (car args) (cadr args)))))
    (- . ,(lambda (k args) (k (- (car args) (cadr args)))))
    (* . ,(lambda (k args) (k (* (car args) (cadr args)))))
    (/ . ,(lambda (k args) (k (/ (car args) (cadr args)))))
    (mod . ,(lambda (k args) (k (mod (car args) (cadr args)))))))

(define (run-program p)
  (let* ((defines (collect-defines p)))
    (eval-program p '() (append (map (lambda (d) (cons d (box '()))) defines) builtins) (lambda (x) x))))

(let ((args (command-line)))
  (display (run-program (file->sexp-list (cadr args))))
  (newline))
