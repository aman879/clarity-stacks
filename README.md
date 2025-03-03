
# Basic Clarity Syntax Guide

Clarity is a decidable, interpreted, and Turing-incomplete smart contract language used on the Stacks blockchain. It does not support loops or recursion, making it secure and predictable.

## Comments
```clarity
;; This is a single-line comment

;; Multi-line comment
;;
;; This is a comment block
;;
```

## Constants
```clarity
(define-constant PI u314159) ;; Defines a constant (cannot be changed)
```

## Variables

```clarity
(define-data-var counter uint u0) ;; Defines a mutable variable

(define-public (increment-counter)
  (begin
    (var-set counter (+ (var-get counter) u1)) ;; Updates the variable
    (ok (var-get counter))))
```

## Data Types

### Unsigned Integer (uint)

```clarity
(define-constant some-number uint u100)
```

### Boolean (bool)
```clarity

(true) ;; True
(false) ;; False
```

### Strings (UTF-8 and ASCII)

```clarity
(define-constant greeting (string-utf8 20) u"Hello, Stacks!")
(define-constant name (string-ascii 10) "Alice")
```

### Optional (none and some values)

```clarity
(some u42) ;; An optional value
(none)     ;; No value
```

### Tuples

```clarity
{ name: "Alice", age: u25 } ;; A tuple (like a struct)
```

### Lists

```clarity
(list u1 u2 u3) ;; List of unsigned integers
```

## Functions

### Public Functions (Callable by Anyone)

```clarity
(define-public (say-hello)
  (ok "Hello, Stacks!")) ;; Returns an `ok` response
```

### Read-Only Functions (No State Change)

```clarity
(define-read-only (get-number)
  u42)
```

## Conditionals and Control Flow

### If Statement

```clarity
(if (> u5 u3)
    "5 is greater"
    "3 is greater")
```

### Match (Pattern Matching)

```
(match (some u10)
  some-value (+ some-value u1) ;; If `some` exists, increment value
  u0) ;; If `none`, return 0
```

## Error Handling

```clarity
(define-constant ERR_INVALID_INPUT u100)

(define-public (check-age (age uint))
  (if (< age u18)
      (err ERR_INVALID_INPUT) ;; Returns an error
      (ok "Allowed")))        ;; Returns success
```
 
## Smart Contract Storage

```clarity
(define-map users ((id uint)) ((name (string-ascii 10)) (balance uint)))

(define-public (add-user (id uint) (name (string-ascii 10)) (balance uint))
  (begin
    (map-set users { id: id } { name: name, balance: balance })
    (ok "User added")))
```

## Calling Other Contracts

```clarity
(define-public (call-other-contract (user principal))
  (contract-call? 'SP123ABC.other-contract some-function user))
```

## Token Transfers (Example with STX)

```clarity
(define-public (send-stx (recipient principal) (amount uint))
  (stx-transfer? amount tx-sender recipient))
```


