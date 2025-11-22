# abcoin

A simple fungible token smart contract written in [Clarity](https://docs.stacks.co/docs/write-smart-contracts/clarity-overview) and managed with [Clarinet](https://docs.hiro.so/clarinet). The `abcoin` contract implements a basic fungible token called **ABCoin (ABC)** that users can mint, transfer, and burn on a local Stacks devnet.

## Features

- Fungible token definition: `define-fungible-token abcoin`
- Public functions:
  - `mint` – mint new tokens to the caller
  - `transfer` – transfer tokens to another principal
  - `burn` – burn tokens from the caller
- Read-only helpers:
  - `get-balance` – get a principal's balance
  - `get-total-supply` – get the total minted supply minus burned tokens
  - `get-name`, `get-symbol`, `get-decimals` – basic token metadata

## Project structure

Key files and directories:

- `Clarinet.toml` – Clarinet project configuration
- `contracts/abcoin.clar` – main smart contract implementation
- `tests/abcoin.test.ts` – placeholder Vitest test file for the contract
- `settings/` – Clarinet network configuration files (Devnet, Testnet, Mainnet)

## Prerequisites

- [Rust toolchain](https://www.rust-lang.org/tools/install) (recommended by Clarinet)
- [Clarinet](https://docs.hiro.so/clarinet) installed and on your `PATH`

To verify Clarinet is installed:

```bash path=null start=null
clarinet --version
```

You should see an output similar to:

```bash path=null start=null
clarinet 3.x.x
```

## Getting started

Clone the repository and move into the project directory:

```bash path=null start=null
git clone <your-fork-or-origin-url>
cd abcoin
```

### Check the contract

Run Clarinet's static analysis and type checks against all contracts in the `contracts/` directory:

```bash path=null start=null
clarinet check
```

If everything is set up correctly, this should complete without errors.

### Open a Clarinet console (simnet)

To interact with the contract on a local simulated network:

```bash path=null start=null
clarinet console
```

Inside the console, you can call functions on the `abcoin` contract. Examples assume the project owner address is `deployer` (Clarinet's default deployer account):

```bash path=null start=null
;; Mint 1,000 ABC to the deployer
(contract-call? .abcoin mint u1000)

;; Check deployer balance
(contract-call? .abcoin get-balance tx-sender)

;; Transfer 100 ABC to another principal
(contract-call? .abcoin transfer u100 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA)

;; Burn 50 ABC from caller
(contract-call? .abcoin burn u50)

;; Read total supply
(contract-call? .abcoin get-total-supply)
```

> Note: In `clarinet console`, you can also use pre-defined accounts like `wallet_1`, `wallet_2`, etc., via the Clarinet JS testing environment. See the tests section below for more.

## Testing

This project is scaffolded with a TypeScript/Vitest test setup.

Install dependencies:

```bash path=null start=null
npm install
```

Run tests:

```bash path=null start=null
npm test
```

The sample test file is in `tests/abcoin.test.ts`. You can extend it with scenarios that:

- Mint tokens for specific accounts
- Transfer tokens between accounts
- Burn tokens and assert that `get-total-supply` is updated correctly

## Contract interface

Public entry points:

```clarity path=null start=null
(define-public (mint (amount uint)) ...)
(define-public (transfer (amount uint) (recipient principal)) ...)
(define-public (burn (amount uint)) ...)
```

Read-only functions:

```clarity path=null start=null
(define-read-only (get-balance (owner principal)) ...)
(define-read-only (get-total-supply) ...)
(define-read-only (get-name) ...)
(define-read-only (get-symbol) ...)
(define-read-only (get-decimals) ...)
```

### Notes

- All public functions validate that `amount` is greater than zero.
- `total-supply` is tracked in a data variable and updated on `mint` and `burn`.
- Any principal can mint tokens for themselves in this basic example. For production,
  you would typically restrict `mint` to a specific admin or contract.
