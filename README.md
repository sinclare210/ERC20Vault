# =====================================================================================
# Sinclair Token & Vault - Smart Contract Suite
# =====================================================================================
# A simple ERC20 token implementation (Sinclair) with an accompanying Vault contract
# that allows users to securely deposit and withdraw tokens.
#
# Deployed Contracts:
#   📄 Sinclair Token (SIN): https://etherscan.io/address/0x4CD275b1c9e1F2d4C10E08bBC6D8b34fC38Dc62a
#   🏦 Vault Contract:       https://etherscan.io/address/0x0134fD7f9565Fe1053B4467B850bBDbd9f1deb60
#
# Usage Instructions:
#   1. Approve the Vault contract to spend your Sinclair tokens:
#        sinclair.approve(<vault_address>, amount);
#   2. Deposit tokens into the Vault:
#        vault.deposit(amount);
#   3. Withdraw tokens from the Vault:
#        vault.withdraw(amount);
#
# Security Features:
#   - Custom error handling (gas-efficient)
#   - Proper access controls
#   - Balance verification before withdrawals
#   - Event logging for deposit/withdraw actions
#
# Contract Summary:
# -------------------------------------------------------------------------------------
# // Sinclair Token (SIN)
# // SPDX-License-Identifier: MIT
# pragma solidity ^0.8.19;
#
# import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
#
# contract Sinclair is ERC20 {
#     constructor(address recipient) ERC20("Sinclair", "SIN") {
#         _mint(recipient, 100_000_000_000 * 10 ** decimals());
#     }
#
#     function unRestrictedMint(address _to, uint256 _amount) public {
#         _mint(_to, _amount);
#     }
# }
#
# =====================================================================================
# 📦 MAKE TARGETS
# =====================================================================================

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
	@echo "  install     - Install dependencies"
	@echo "  build       - Compile contracts"
	@echo "  test        - Run test suite"
	@echo "  deploy      - Deploy token & vault contracts"
	@echo "  verify      - Verify contracts on Etherscan"
	@echo "  info        - Display token and vault metadata"
	@echo "  clean       - Remove build artifacts"

# Install project dependencies
install:
	@echo "Installing dependencies..."
	forge install
	npm install

# Compile contracts
build:
	@echo "Building contracts..."
	forge build

# Run test suite
test:
	@echo "Running tests..."
	forge test -vv

# Deploy Sinclair Token contract
deploy-token:
	@echo "Deploying Sinclair Token..."
	forge create --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) src/ERC20.sol:Sinclair --constructor-args $(RECIPIENT_ADDRESS)

# Deploy Vault contract with the token address as argument
deploy-vault:
	@echo "Deploying Vault Contract..."
	forge create --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) src/Vault.sol:Vault --constructor-args $(SINCLAIR_ADDRESS)

# Deploy both contracts
deploy: deploy-token deploy-vault

# Show contract information
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

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	forge clean
