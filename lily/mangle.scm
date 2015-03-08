;; Mangling

(define (flatten lists) (apply append lists))

(define (quoted-string s)
  (let ((escape (lambda (khar)
                  (case khar
                    ((#\\) (list #\\ #\\))
                    ((#\") (list #\\ #\"))
                    ((#\newline) (list #\\ #\n))
                    (else (list khar))))))
    (list->string (append (list #\")
                          (flatten (map  escape (string->list s)))
                          (list #\")))))

(define (mangle-symbol sym)
  (let ((escape (lambda (khar)
                  (case khar
                    ((#\-) (string->list "_"))
                    ((#\>) (string->list "_to"))
                    ((#\*) (string->list "_star"))
                    ((#\_) (string->list "_underscore"))
                    ((#\?) (string->list "_question"))
                    ((#\!) (string->list "_bang"))
                    (else (list khar)))))
        (escape-keywords (lambda (l)
                           (match l
                             (`(#\c #\h #\a #\r)
                              (append (list #\s #\y #\m #\_ ) l))
                             (`(#\s #\y #\m . ,rest)
                              (append (list #\s #\y #\m #\_ #\s #\y #\m)
                                      rest))
                                 (else l))))
        (fixup (lambda (s)
                 (if (equal? "_bang" s)
                     "!"
                     s))))
    (fixup (list->string (escape-keywords (flatten (map escape (string->list (symbol->string sym)))))))))
