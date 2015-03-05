(define-library (lily compile)
  (import (scheme base)
          (scheme write)
          (match match))
  (export
    compile-program
    compile-definition

    apply-function)
  (include "compile.scm"))
