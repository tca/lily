(import (scheme base)
        (match match)
        (util file) ;; for file->sexp-list
        (lily recognize)
        (lily compile)
        (lily asm))

;; sagittarius -Lmatch-sagittarius -L. -S.sld -d lily.scm t1

(define (read-program filename)
  (let ((code (file->sexp-list filename)))
    (unless (parse-program code)
            (error "Invalid code!"))
    code))

(let ((test (cadr (command-line))))
  (let ((code (read-program (string-append "other-tests/" test ".scm"))))
    ;(print 'read-program)
    ;(print (list 'program-names ': (extract-names code)))
    (let ((compiled (compile-program code)))
      ;(print 'compiled-program)
      ;(for-each print compiled)
      ;(print 'assembly)
      (for-each print-asm compiled)
      ;; (let ((result 0))
      ;;   (print 'executed-program)
      ;;   (print (list 'result result)))
      )))

