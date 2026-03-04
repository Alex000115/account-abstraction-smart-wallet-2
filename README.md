# Account Abstraction Smart Wallet (ERC-4337)

This repository provides a high-quality, production-ready foundation for building Smart Contract Wallets using the ERC-4337 standard. It moves away from the limitations of Externally Owned Accounts (EOAs) to provide a superior user experience.

## Features
- **ERC-4337 Compliant**: Fully compatible with Bundlers and EntryPoint contracts.
- **Paymaster Support**: Architecture ready for gasless transactions where a third party pays the fee.
- **Signature Abstraction**: Supports custom validation logic beyond standard ECDSA (e.g., multisig or P256).
- **Security Guards**: Built-in reentrancy protection and strict access control for the EntryPoint.



## Technical Flow
1. **UserOp**: The user signs a `UserOperation` instead of a raw transaction.
2. **Bundler**: A bundler collects these operations and sends them to the `EntryPoint` contract.
3. **Validation**: The `EntryPoint` calls `validateUserOp` on this contract to verify the signature.
4. **Execution**: If valid, the `EntryPoint` executes the target call.

## Setup
- Build: `forge build`
- Test: `forge test`
