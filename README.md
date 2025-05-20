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

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault Contract
 * @author Sinclare210
 * @notice This contract allows users to deposit and withdraw a specific ERC20 token,
 * even if the token does not return a boolean value on transfer (e.g., USDT).
 * @dev Uses low-level `call` to handle non-compliant ERC20 tokens.
 */
contract Vault {
    address public immutable token;
    mapping(address => uint256) public balances;
    uint256 public contractBalance;

    error ZeroNotAllowed();
    error InsufficientVaultBalance();

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _token) {
        token = _token;
    }

    function safeTransfer(address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    function safeTransferFrom(address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        safeTransferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] += _amount;
        contractBalance += _amount;
        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();
        balances[msg.sender] -= _amount;
        contractBalance -= _amount;
        safeTransfer(msg.sender, _amount);
        emit Withdrawn(msg.sender, _amount);
    }
}
```

---

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
