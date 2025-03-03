(define-constant ERR_INVALID_STRING u0)
(define-constant ERR_MESSAGE_TOO_LONG u1)

(define-data-var custom-message (string-ascii 500) "Hello")

(define-public (set-message (message (string-ascii 500)))
    (if (<= (len message) u500)
        (if (var-set custom-message message)
            (ok true)
            (err ERR_INVALID_STRING)    
        )
        (err ERR_MESSAGE_TOO_LONG)
    )
)

(define-read-only (get-message)
    (var-get custom-message)
)
