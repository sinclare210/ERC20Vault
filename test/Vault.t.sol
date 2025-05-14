// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;

    function setUp() external {
        vault = new Vault(0x3F2ce71A3e46d57C89ECDE315D7b382CE20D600a);
    }

    function testDepositSuccess() public {
        // Should deposit tokens successfully
    }

    function testDepositZeroReverts() public {
        // Should revert when deposit amount is zero
    }

    function testDepositWithoutApprovalReverts() public {
        // Should revert if no approval is given
    }

    function testDepositInsufficientApprovalReverts() public {
        // Should revert if approved amount is less than deposit
    }

    function testDepositFailsIfTransferFromReturnsFalse() public {
        // Should revert if token’s transferFrom returns false
    }

    function testWithdrawSuccess() public {
        // Should withdraw deposited tokens successfully
    }

    function testWithdrawZeroReverts() public {
        // Should revert when withdrawal amount is zero
    }

    function testWithdrawMoreThanBalanceReverts() public {
        // Should revert when withdrawing more than deposited
    }

    function testWithdrawFailsIfTransferReturnsFalse() public {
        // Should revert if token’s transfer returns false
    }

    function testBalancesUpdatedCorrectlyOnDeposit() public {
        // Vault and user balances should increase accordingly
    }

    function testBalancesUpdatedCorrectlyOnWithdraw() public {
        // Vault and user balances should decrease accordingly
    }

    function testMultipleDepositsAccumulateCorrectly() public {
        // Repeated deposits by one user should be cumulative
    }

    function testMultipleUsersTrackedIndependently() public {
        // Separate users can deposit/withdraw independently
    }

    function testDepositedEventEmitted() public {
        // Should emit Deposited event with correct args
    }

    function testWithdrawnEventEmitted() public {
        // Should emit Withdrawn event with correct args
    }
}
