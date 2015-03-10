(define (qword o)
  (string-append "qword " o))
 
(define (jmp= n k)
  (push! `(cmp rax ,n))
  (push! `(je ,k)))

(define (print-indent)
  (display "        "))

(define (print-asm x)
  (cond 
   ((string? x) (print-indent) (display x) (newline))
   ((equal? 'label (car x)) (print-label x))
   ((equal? 'local-label (car x)) (print-local-label x))
   ((equal? 'include (car x)) (print-include x))
   (else  (print-instr x))))

(define (print-label x)
  (newline)
  (display (cadr x))
  (display ":")
  (newline))

(define (print-local-label x)
  ;; TODO error if x does not start with .
  (display (cadr x))
  (display ":")
  (newline))

(define (print-include x)
  (display "%include ")
  (display "\"")
  (display (cadr x))
  (display "\"")
  (newline))

(define (display-operand rand)
  (cond
   ((string? rand) (display rand))
   ((symbol? rand) (display rand))
   ((number? rand) (display rand))
   ((list? rand)
    (cond ((and (= 3 (length rand))
                (eq? '+ (car rand)))
           (display "[")
           (display (cadr rand))
           (display "+")
           (display (caddr rand))
           (display "]"))
          (else (error "fail2 in asm"))))
   (else (error "fail in asm" rand))))

(define (print-instr x)
  (let ((l (length x)))
    (cond
     ((= l 3) (begin
                (print-indent)
                (display-operand (car x))
                (display " ")
                (display-operand (cadr x))
                (display ", ")
                (display-operand (caddr x))
                (newline)))
     ((= l 2) (begin
                (print-indent)
                (display-operand (car x))
                (display " ")
                (display-operand (cadr x))
                (newline)))
     ((= l 1) (begin
                (print-indent)
                (display-operand (car x))
                (newline))))))
