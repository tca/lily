(define-library (lily compile)
  
  (import (scheme base)
          (match match)
          (lily sequence)
          (lily mangle))

  (export
    compile-program)

  (include "compile.scm"))

