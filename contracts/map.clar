(define-constant ERR_NAME_TOO_LONG u0)
(define-constant ERR_INVALID_BALANCE u1)

(define-data-var g-id uint u0)

;;map(int => struct) user
;;user[id]
(define-map users 
                { id: uint }  ;;key
                { ;;value
                    name: (string-ascii 20), 
                    address: principal,  
                    balance: uint 
                }
)

(define-public (add-user (name (string-ascii 20)) (balance uint)) 
    (begin
        (if (> (len name) u20)
            (err ERR_NAME_TOO_LONG)
            (if (<= balance u0)
                (err ERR_INVALID_BALANCE)
                (begin
                    (map-set users 
                        {id: (var-get g-id)} 
                        {
                            name: name,
                            address: tx-sender,
                            balance: balance
                        }
                    )
                    (var-set g-id (+ (var-get g-id) u1))
                    (ok "User added")
                )
            )
        )
    )
)

(define-read-only (get-user (id uint)) 
    (map-get? users {id: id})
)

(define-read-only (get-total-user)
    (var-get g-id)
)
