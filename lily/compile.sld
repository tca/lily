(define-library (lily compile)
  
  (import (scheme base)
          (match match)
          (lily sequence))

  (export
    compile-program)

  (include "compile.scm"))

