# 🏦 Sinclair Vault

A secure smart contract vault that allows users to deposit and withdraw ERC20 tokens, including non-standard tokens like USDT.

---

## 📚 Overview

This repository contains a Solidity smart contract:

- **Vault Contract** – A robust vault enabling deposits and withdrawals for any ERC20 token, including those that do not return a boolean value on `transfer` and `transferFrom`.

---

## 🧾 Contract Details

### ✅ Vault Contract

The Vault supports safe transfers even for non-compliant ERC20 tokens like USDT by using low-level `call`. It includes:

- **Custom errors** for gas-efficient reverts
- **Secure internal balance tracking**
- **Event logging** for deposits and withdrawals


## 🚀 Features

- ✅ Handles non-standard ERC20 tokens like USDT
- 🔒 Custom errors for secure, gas-efficient validation
- 📢 Emits events for traceability
- 🔄 Safe balance tracking

---

## 🔧 Usage

### 📥 Depositing Tokens

1. **Approve the Vault contract** to spend tokens:

```solidity
IERC20(tokenAddress).approve(vaultAddress, amount);
```

2. **Call deposit**:

```solidity
vault.deposit(amount);
```

---

### 📤 Withdrawing Tokens

```solidity
vault.withdraw(amount);
```

---

## 🛠 Development & Deployment

### 📋 Requirements

- Foundry or Hardhat
- OpenZeppelin Contracts
- Node.js (for frontend or toolchain)

### 🧪 Testing

Use Foundry or Hardhat to write and execute unit tests verifying:

- Deposit & withdraw flow
- Reverts on 0 input or excess withdraw
- Safe transfer behavior

---

## 📄 License

MIT License
