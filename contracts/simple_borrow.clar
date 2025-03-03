(define-constant ERR_NOT_ENOUGH_BALANCE u0)
(define-constant ERR_TRANSFER_FAILED u1)

(define-constant PROPERTY u101)
(define-constant GOLD u102)
(define-constant SILVER u103)
(define-constant DIAMOND u104)

(define-data-var g-loanID uint u0)

(define-map balances 
    { owner: principal } 
    { balance: uint }
)

(define-map loan 
    { loanID: uint } 
    { 
        loaner: principal, 
        borrower: principal, 
        collateral: uint, 
        amount: uint
    }
)

;; (define-public (deposit (amount uint))
;;   (let ((transfer-result (stx-transfer? amount tx-sender (as-contract tx-sender))))
;;     (if (is-ok transfer-result)
;;       (begin
;;         (map-set balances
;;           {owner: tx-sender}
;;           {balance: (+ amount (default-to u0 (get balance (map-get? balances {owner: tx-sender}))))}
;;         )
;;         (ok "User deposit successful!")
;;       )
;;       (err u1) 
;;     )
;;   )
;; )


(define-public (deposite (amount uint))
    (begin
        (if (> amount u0)
            (begin
                (unwrap! (stx-transfer? amount tx-sender (as-contract tx-sender)) (err ERR_TRANSFER_FAILED))
                (map-set balances
                    {owner: tx-sender}
                    {balance: (+ amount 
                                (default-to u0 
                                    (get balance 
                                        (map-get? balances 
                                            {owner: tx-sender}
                                        )
                                    )
                                )
                            )
                    }
                )
                (ok "Deposit succesfull")
            )
            (err ERR_NOT_ENOUGH_BALANCE)
        )
    )
)

(define-public (withdraw (amount uint))
  (begin
    (if (> amount u0)
        (let ((current-balance 
                (default-to u0 
                    (get balance 
                        (map-get? balances {owner: tx-sender})
                    )
                )
            ))
            (if (>= current-balance amount)
              (begin
                (unwrap! (stx-transfer? amount tx-sender contract-caller) (err u1))
                (map-set balances {owner: tx-sender} {balance: (- current-balance amount)})
                (ok "User withdrawal successful") 
              )
              (err u0)
            )
        )
        (err u0) 
    )
  )
)


(define-public (give-loan (borrower principal) (amount uint) (collateral-type uint))
    (begin
        (if (and 
                (> amount u0) 
                (is-eq borrower borrower) 
                (or
                    (is-eq collateral-type PROPERTY)
                    (is-eq collateral-type SILVER)
                    (is-eq collateral-type GOLD)
                    (is-eq collateral-type DIAMOND)
                )
            )
            (let ((current-balance
                    (default-to u0
                        (get balance
                            (map-get? balances 
                                {owner: tx-sender}
                            )
                        )
                    )
                ))
                (if (>= current-balance amount)
                    (begin 
                        (map-set balances
                            {owner: tx-sender}
                            {balance: (- current-balance amount)}
                        )
                        (map-set balances
                            {owner: borrower}
                            {balance: (+ (default-to u0 
                                            (get balance
                                                (map-get? balances
                                                    {owner: borrower}
                                                )
                                            )
                                        )
                                        amount
                                    )
                            }
                        )
                        (map-set loan
                            {loanID: (var-get g-loanID)}
                            {
                                loaner: tx-sender,
                                borrower: borrower,
                                collateral: collateral-type,
                                amount: amount
                            }
                        )
                        (var-set g-loanID (+ (var-get g-loanID) u1))
                        (ok "Loan success")
                    )
                    (err u0)
                )
            )
            (err u0)
        )
    )
)

(define-read-only (check-balance)
    (map-get? balances
        {owner: tx-sender}
    )
)

(define-read-only (check-balance-of (of principal))
    (map-get? balances
        {owner: of}
    )
)


(define-read-only (check-loan (loanID uint))
    (map-get? loan 
        {loanID: loanID}
    )
)
