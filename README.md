Sinclair Token & Vault
.PHONY: all test build install deploy help
SINCLAIR_ADDRESS := 0x4CD275b1c9e1F2d4C10E08bBC6D8b34fC38Dc62a
VAULT_ADDRESS := 0x0134fD7f9565Fe1053B4467B850bBDbd9f1deb60
RPC_URL := <your_rpc_url>
PRIVATE_KEY := <your_private_key>
RECIPIENT_ADDRESS := <recipient_address>
help:
@echo "Sinclair Token & Vault"
@echo ""
@echo "A simple ERC20 token implementation with an accompanying vault contract"
@echo "allowing users to deposit and withdraw tokens securely."
@echo ""
@echo "Deployed Contracts:"
@echo "  Sinclair Token (SIN): https://etherscan.io/address/$(SINCLAIR_ADDRESS)"
@echo "  Vault Contract: https://etherscan.io/address/$(VAULT_ADDRESS)"
@echo ""
@echo "Available targets:"
@echo "  install    - Install dependencies"
@echo "  build      - Compile contracts"
@echo "  test       - Run test suite"
@echo "  deploy     - Deploy contracts"
@echo "  verify     - Verify contracts on Etherscan"
@echo ""
all: install build test
Installation
install:
@echo "Installing dependencies..."
forge install
npm install
Build the project
build:
@echo "Building contracts..."
forge build
Run tests
test:
@echo "Running tests..."
forge test -vv
Deploy contracts
deploy-token:
@echo "Deploying Sinclair Token..."
forge create --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) src/ERC20.sol:Sinclair --constructor-args $(RECIPIENT_ADDRESS)
deploy-vault:
@echo "Deploying Vault Contract..."
forge create --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) src/Vault.sol:Vault --constructor-args $(SINCLAIR_ADDRESS)
deploy: deploy-token deploy-vault
Contract Information
info:
@echo "Sinclair Token (SIN)"
@echo "---------------------"
@echo "Address: $(SINCLAIR_ADDRESS)"
@echo "Symbol: SIN"
@echo "Name: Sinclair"
@echo "Decimals: 18"
@echo "Initial Supply: 100,000,000,000 tokens"
@echo ""
@echo "Vault Contract"
@echo "-------------"
@echo "Address: $(VAULT_ADDRESS)"
@echo "Token: $(SINCLAIR_ADDRESS)"
Contract Details (for documentation purposes)
contract-details:
@echo "// Sinclair Token (SIN)"
@echo "// SPDX-License-Identifier: MIT"
@echo "pragma solidity ^0.8.19;"
@echo ""
@echo "import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";"
@echo ""
@echo "contract Sinclair is ERC20 {"
@echo "    constructor(address recipient) ERC20("Sinclair", "SIN") {"
@echo "        _mint(recipient, 100000000000 * 10 ** decimals());"
@echo "    }"
@echo ""
@echo "    function unRestrictedMint(address _to, uint256 _amount) public {"
@echo "        _mint(_to, _amount);"
@echo "    }"
@echo "}"
usage:
@echo "Usage Instructions"
@echo "-----------------"
@echo "1. Approve the Vault contract to spend your Sinclair tokens:"
@echo "   sinclair.approve($(VAULT_ADDRESS), amount);"
@echo ""
@echo "2. Deposit tokens to the Vault:"
@echo "   vault.deposit(amount);"
@echo ""
@echo "3. Withdraw tokens from the Vault:"
@echo "   vault.withdraw(amount);"
Security features for documentation
security:
@echo "Security Features"
@echo "----------------"
@echo "- Custom error handling for better gas efficiency"
@echo "- Proper access controls"
@echo "- Balance verification before withdrawals"
@echo "- Event emission for important state changes"
Clean build artifacts
clean:
@echo "Cleaning build artifacts..."
forge clean
License
license:
@echo "MIT License"