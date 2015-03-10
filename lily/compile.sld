(define-library (lily compile)
  
  (import (scheme base)
          (sagittarius)
          (match match)
          (lily sequence)
          (lily mangle))

  (export
    compile-program)

  (include "compile.scm"))

