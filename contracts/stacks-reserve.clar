;; StacksReserve Protocol: Bitcoin-native Stablecoin Platform
;;
;; A decentralized stablecoin protocol built on Stacks with Bitcoin finality.
;; This contract enables users to create overcollateralized vaults using STX 
;; and xBTC as collateral to mint USDx, a USD-pegged stablecoin.
;;
;; Key features:
;; - Multi-collateral vaults (STX and xBTC supported)
;; - SIP-010 compliant USDx token
;; - Configurable collateralization ratios
;; - Price oracle integration
;; - Liquidation engine for undercollateralized positions

;; Constants and Error Codes

(define-constant CONTRACT-OWNER tx-sender)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-VAULT-NOT-FOUND (err u1001))
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u1002))
(define-constant ERR-VAULT-UNDERCOLLATERALIZED (err u1003))
(define-constant ERR-LIQUIDATION-NOT-ALLOWED (err u1004))
(define-constant ERR-INVALID-AMOUNT (err u1005))
(define-constant ERR-ORACLE-PRICE-STALE (err u1006))
(define-constant ERR-MINIMUM-COLLATERAL-RATIO (err u1007))
(define-constant ERR-VAULT-ALREADY-EXISTS (err u1008))
(define-constant ERR-INSUFFICIENT-USDX-BALANCE (err u1009))
(define-constant ERR-TRANSFER-FAILED (err u1010))

;; Protocol Parameters
(define-constant LIQUIDATION-RATIO u150) ;; 150% - liquidation threshold
(define-constant MINIMUM-COLLATERAL-RATIO u200) ;; 200% - minimum for new vaults
(define-constant LIQUIDATION-PENALTY u110) ;; 10% liquidation penalty
(define-constant STABILITY-FEE-RATE u2) ;; 2% annual stability fee
(define-constant MAX-PRICE-AGE u3600) ;; 1 hour max price age (in seconds)

;; Data Structures

;; Vault structure
(define-map vaults
  { vault-id: uint }
  {
    owner: principal,
    stx-collateral: uint,
    xbtc-collateral: uint,
    debt: uint,
    last-update: uint,
    is-active: bool,
  }
)

;; User vault mapping
(define-map user-vaults
  { user: principal }
  { vault-ids: (list 10 uint) }
)

;; Price feeds from oracle
(define-map price-feeds
  { asset: (string-ascii 10) }
  {
    price: uint,
    timestamp: uint,
    confidence: uint,
  }
)

;; Protocol statistics
(define-data-var total-vaults uint u0)
(define-data-var total-debt uint u0)
(define-data-var total-stx-collateral uint u0)
(define-data-var total-xbtc-collateral uint u0)
(define-data-var liquidation-pool uint u0)

;; Authorized liquidators
(define-map authorized-liquidators
  principal
  bool
)

;; Oracle operators
(define-map oracle-operators
  principal
  bool
)

;; USDx Token Implementation (SIP-010)

(define-fungible-token usdx)

(define-data-var token-name (string-ascii 32) "USDx Stablecoin")
(define-data-var token-symbol (string-ascii 10) "USDx")
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var token-decimals uint u6)

;; SIP-010 Standard Functions
(define-read-only (get-name)
  (ok (var-get token-name))
)