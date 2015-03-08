(define-library (lily mangle)

   (import (scheme base)
           (scheme cxr)
           (match match))

   (export quoted-string
           mangle-symbol)

   (include "mangle.scm"))
   