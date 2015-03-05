(import (scheme base)
        (match match)
        (util file) ;; for file->sexp-list
        (lily recognize)
        (lily compile))

;; sagittarius -Lmatch-sagittarius -L. -S.sld -d lily.scm

(define (read-program filename)
  (let ((code (file->sexp-list filename)))
    (unless (parse-program code)
            (error "Invalid code!"))
    code))

(let ((code (read-program "other-tests/t1.scm")))
  (print 'read-program)
  (let ((compiled (compile-program code)))
    (print 'compiled-program)
    (let ((result (apply-function compiled 'foo (list 7))))
      (print 'executed-program)
      (print (list 'result result)))))

