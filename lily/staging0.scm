(define (eval0 exp params args toplevel k)
  (match exp
    ((number? x) (k x)) ;; call continuation with value
    ((symbol? x) (k (nth (lookup-calc x params) args)))
    (`(+ ,x ,y)
     (eval0 x params args toplevel
            (lambda (x-evald)
              (eval0 y params args toplevel
                     (lambda (y-evald)
                       (k (+ x-evald y-evald)))))))))

;; IDEA
;; (eval0 exp params args toplevel k)
;; = (execute0 (prepare0 exp params toplevel) args toplevel k)

(define (prepare0 exp params toplevel)
  (match exp
    ((number? x) `(number ,x)) ;; call continuation with value
    ((symbol? x) `(arg (lookup-calc x params)))
    (`(+ ,x ,y)
      (let ((x1 (prepare0 x params toplevel))
             (y1 (prepare0 y params toplevel)))
      `(+ ,x1 ,y1))))

(define (execute0 exp args toplevel k)
  (match exp
    (`(number ,x) (k x)) ;; call continuation with value
    (`(arg ,i) (k (nth i args)))
    (`(+ ,x ,y)
     (execute0 x params args toplevel
            (lambda (x-evald)
              (execute0 y params args toplevel
                     (lambda (y-evald)
                       (k (+ x-evald y-evald)))))))))


(let ((params '(x))
      (args '(1))
      (toplevel '())
      (k (lambda (x) x)))
  (execute0 (prepare0 '(+ x 1) params toplevel) args toplevel k))


;; eval1 is sort of like prepare and execute in one function
;; with a lambda delaying between them
;; this is how the staging normally works
;; the second stage is tagless

;; cps based compiler that makes normal terms
(define (eval1 exp paramstoplevel k)
  (match exp
    ((number? x) (k  (lambda (args) x))) 
    ((symbol? x) (let ((n (lookup-calc x params)))
                   (k (lambda (args) (nth n args)))))
    (`(+ ,x ,y)
     (eval1 x params toplevel
            (lambda (x-evald)
              (eval1 y params oplevel
                     (lambda (y-evald)
                       (k (lambda (args) (+ (x-evald args) (y-evald args)))))))))))


(let ((params '(x))
       (args '(1))
       (toplevel '())
       (k (lambda (x) (lambda (args) x))))
  ((prepare0 '(+ x 1) params toplevel k) args))


;; normal compiler that makes cps'd terms
(define (eval2 exp params toplevel)
  (match exp
    ((number? x) (lambda (args k) (k x)))
    ((symbol? x) (let ((n (lookup-calc x params)))
                   (lambda (args k) (k (nth n args)))))
    (`(+ ,x ,y)
     (let ((x-evald (eval2 x params toplevel))
           (y-evald (eval2 y params toplevel)))
       (lambda (args k)
         (x-evald args (lambda (x-executed)
                         (y-evald args (lambda (y-executed)
                                         (+ x-executed y-executed))))))))))

;; (k  (lambda (args) x))
;; (k (lambda (args) (nth n args))
;; (eval1 x params toplevel   (lambda (x-evald) ...
;;
;; In the first two K is passed in a function that takes (lambda (args) ..)
;; In the final one, we pass in a continuation that expects to recieve a
;; (lambda (args) ...) called x-evald.


                       
