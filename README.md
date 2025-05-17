
# 🏦 Sinclair Token & Vault

A simple ERC20 token implementation with an accompanying vault contract allowing users to deposit and withdraw tokens securely.

---

## 📚 Overview

This repository contains two main Solidity smart contracts:

- **Sinclair Token (SIN)** – An ERC20 token with unrestricted minting capabilities.
- **Vault Contract** – A secure vault allowing users to deposit and withdraw Sinclair tokens.

---

## 📍 Deployed Contracts

- **Sinclair Token (SIN)**: `0x4CD275b1c9e1F2d4C10E08bBC6D8b34fC38Dc62a`  
- **Vault Contract**: `0x0134fD7f9565Fe1053B4467B850bBDbd9f1deb60`

---

## 🧾 Contract Details

### ✅ Sinclair Token (SIN)

A basic ERC20 token with:

- **Symbol**: SIN  
- **Name**: Sinclair  
- **Decimals**: 18  
- **Initial Supply**: 100,000,000,000 tokens (minted to deployer)  
- **Feature**: Unrestricted minting

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Sinclair is ERC20 {
    constructor(address recipient) ERC20("Sinclair", "SIN") {
        _mint(recipient, 100000000000 * 10 ** decimals());
    }

    function unRestrictedMint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
```

---

### ✅ Vault Contract

A secure vault for depositing and withdrawing Sinclair tokens.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault Contract
 * @notice This contract allows users to deposit and withdraw a specific ERC20 token.
 */
contract Vault {
    IERC20 public immutable token;
    mapping(address => uint256) public balances;
    uint256 public contractBalance;

    error ZeroNotAllowed();
    error InsufficientAllowance();
    error InsufficientVaultBalance();

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        bool success = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "deposit failed");
        balances[msg.sender] += _amount;
        contractBalance += _amount;
        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();
        balances[msg.sender] -= _amount;
        contractBalance -= _amount;
        bool success = token.transfer(msg.sender, _amount);
        require(success, "Withdraw failed");
        emit Withdrawn(msg.sender, _amount);
    }
}
```

---

## 🚀 Features

- ✅ Deposit & withdrawal functionality  
- 🧮 Balance tracking per user  
- 📢 Event emission for important actions  
- 🔐 Custom error handling for gas efficiency  
- 📊 Transfer validation on token interactions

---

## 🔧 Usage

### 📥 Depositing Tokens

1. **Approve the Vault contract**:
```solidity
sinclair.approve(vaultAddress, amount);
```

2. **Deposit tokens into the Vault**:
```solidity
vault.deposit(amount);
```

---

### 📤 Withdrawing Tokens

Withdraw your tokens:
```solidity
vault.withdraw(amount);
```

---

## 🧪 Testing

The project uses **Foundry** for testing. Here's an example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {Sinclair} from "../src/ERC20.sol";

contract VaultTest is Test {
    function testDepositSuccess() public {
        vm.startPrank(sinc);
        assertEq(vault.balances(sinc), depositAmount);
        assertEq(vault.contractBalance(), depositAmount);
        emit Vault.Deposited(sinc, depositAmount);
        vm.stopPrank();
    }
}
```

Run tests:
```bash
forge test
```

---

## 🛡️ Security Features

- Custom Errors – Gas efficient reverts  
- Access Controls – Validations on user balance & allowance  
- Balance Checks – Prevents overdrawing  
- Transfer Validations – Ensures token movement  
- Event Logging – For better traceability  

---

## 🛠 Development

### 📋 Prerequisites

- [Foundry](https://book.getfoundry.sh/)
- Node.js
- OpenZeppelin Contracts

---

### 📦 Installation

```bash
forge install
npm install
```

---

### 🛠 Compilation

```bash
forge build
```

---

### 🚀 Deployment

#### Deploy the Sinclair Token:
```bash
forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/ERC20.sol:Sinclair --constructor-args <recipient_address>
```

#### Deploy the Vault:
```bash
forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/Vault.sol:Vault --constructor-args <sinclair_token_address>
```

---

## 📄 License

MIT License
