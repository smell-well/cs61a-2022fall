(define-macro (when condition exprs)
    (list 'if condition
          (cons 'begin exprs)
          ''okay
    )
)

; (define-macro (switch expr cases)
; 	(cons _________ ; ?? cons ??
; 		(map (_________ (_________) (cons _________ (cdr case)))
;     			cases))
; )

(define-macro (switch expr cases)
	(cons 'cond
		(map (lambda (case) (cons `(equal? ,expr ',(car case)) (cdr case)))
    			cases))
)

; simplify
; (lambda (case) ((equal? expr (car case)) (cdr case)))

; (eq? (car case) expr)