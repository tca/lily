(define-library (lily asm)

  (import (scheme base)
          (scheme cxr)
          (scheme write)
          (lily mangle))

  (export print-asm print-instr)

  (include "../asm.scm"))
  