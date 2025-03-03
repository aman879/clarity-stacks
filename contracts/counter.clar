(define-data-var counter uint u5) ;;5

(define-public (increment-counter) 
    (begin 
        (var-set counter (+ (var-get counter) u1))
        (ok (var-get counter)) 
    )
)