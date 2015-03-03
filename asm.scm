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
   (else  (print-instr x))))

(define (print-label x)
  (newline)
  (display (cadr x))
  (display ":")
  (newline))

(define (print-instr x)
  (let ((l (length x)))
    (cond
     ((= l 3) (begin
                (print-indent)
                (display (car x))
                (display " ")
                (display (cadr x))
                (display ", ")
                (display (caddr x))
                (newline)))
     ((= l 2) (begin
                (print-indent)
                (display (car x))
                (display " ")
                (display (cadr x))
                (newline)))
     ((= l 1) (begin
                (print-indent)
                (display (car x))
                (newline))))))
