;; title: abcoin
;; version: 1.0.0
;; summary: Simple fungible token for the abcoin project
;; description: |
;;   A basic fungible token implemented in Clarity. Any user can mint,
;;   transfer, and burn their own ABCOIN tokens. This contract tracks
;;   total supply and exposes read-only helpers for balances.

;; token definitions
(define-fungible-token abcoin)

;; constants
(define-constant TOKEN-NAME (some "ABCoin"))
(define-constant TOKEN-SYMBOL (some "ABC"))
(define-constant TOKEN-DECIMALS (some u6))

(define-constant ERR-NON-POSITIVE-AMOUNT u100)

;; data vars
(define-data-var total-supply uint u0)

;; public functions

;; Mint new ABCOIN tokens to the caller.
;; Any user can mint tokens for themselves.
(define-public (mint (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-NON-POSITIVE-AMOUNT))
    (try! (ft-mint? abcoin amount tx-sender))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok amount)))

;; Transfer ABCOIN tokens from the caller to a recipient.
(define-public (transfer (amount uint) (recipient principal))
  (begin
    (asserts! (> amount u0) (err ERR-NON-POSITIVE-AMOUNT))
    (try! (ft-transfer? abcoin amount tx-sender recipient))
    (ok true)))

;; Burn ABCOIN tokens from the caller's balance.
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-NON-POSITIVE-AMOUNT))
    (try! (ft-burn? abcoin amount tx-sender))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok amount)))

;; read only functions

;; Get the ABCOIN balance of a given principal.
(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance abcoin owner)))

;; Get the total supply of ABCOIN.
(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

;; Get token metadata helpers.
(define-read-only (get-name)
  TOKEN-NAME)

(define-read-only (get-symbol)
  TOKEN-SYMBOL)

(define-read-only (get-decimals)
  TOKEN-DECIMALS)
