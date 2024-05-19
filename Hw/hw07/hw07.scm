(define (cddr s) (cdr (cdr s)))

(define (cadr s) (car (cdr s)))

(define (caddr s) (car (cddr s)))

(define (ascending? asc-lst) (if (> (length asc-lst) 1) 
                                 (if (<= (car asc-lst) (cadr asc-lst)) 
                                     (ascending? (cdr asc-lst))
                                     #f) 
                                 #t))

(define (square n) (* n n))

(define (pow base exp) (cond ((= exp 0) 1)
                             ((= exp 1) base)
                             ((= base 1) 1)
                             (else (if (even? exp)
                                       (* (pow base (/ exp 2)) (pow base (/ exp 2)))
                                       (* (pow base (/ (+ exp 1) 2)) (pow base (/ (- exp 1) 2)))))))
