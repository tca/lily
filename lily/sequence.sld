(define-library (lily sequence)
  
  (import (scheme base)
          (match match))

  (export sequence->dlist
          sequence->list)

  (begin
    (define (foldr f z l)
      (if (null? l)
          z
          (f (car l) (foldr f z (cdr l)))))
    
    (define (sequence->dlist s rest)
      (match s
        (`epsilon rest)
        (`(join . ,seqs) (foldr sequence->dlist rest seqs))
        (`(elt ,x) (cons x rest))
        (else (error (list "invalid sequence" s)))))
    
    (define (sequence->list s)
      (sequence->dlist s '())))

  )
