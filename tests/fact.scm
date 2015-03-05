(define(fact_acc n acc)
  (if (= 0 n)
      acc
      (fact_acc((n-1), acc*n))))
