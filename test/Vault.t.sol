// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

import {Sinclair} from "../src/ERC20.sol";

contract VaultTest is Test {
    Vault public vault;
    Sinclair public sinclair;

    uint256 public constant approveAmount = 1000000000000000000000;
    uint256 public constant depositAmount = 100000000000000000000;

    event Deposited(address indexed user, uint256 amount);

    address sinc = address(0x1);

    modifier approveAndDeposit (){
        vm.startPrank(sinc);
        sinclair.approve(address(vault), approveAmount);
        vault.deposit(depositAmount);
        vm.stopPrank;
        _;
    }

    function setUp() external {
        vm.startPrank(sinc);
        sinclair = new Sinclair(sinc);
        sinclair.unRestrictedMint(sinc, 100000000000 * 10 ** 18);
        vm.stopPrank();
        // vault = new Vault(0x3F2ce71A3e46d57C89ECDE315D7b382CE20D600a);
        vault = new Vault(address(sinclair));
        uint256 balance = sinclair.balanceOf(sinc);
        console.log("sinc Balance:", balance);
    }

    function testDepositSuccess() public approveAndDeposit {
        // Should deposit tokens successfully
        vm.startPrank(sinc);
        
        assertEq(vault.balances(sinc), depositAmount);
        assertEq(vault.contractBalance(), depositAmount);

        emit Vault.Deposited(sinc, depositAmount);
        vm.stopPrank();
    }

    function testDepositZeroReverts() public {
        // Should revert when deposit amount is zero
        vm.startPrank(sinc);
        vm.expectRevert(Vault.ZeroNotAllowed.selector);
        vault.deposit(0);
        vm.stopPrank();
    }

    function testDepositWithoutApprovalReverts() public {
        // Should revert if no approval is given
        vm.startPrank(sinc);
        vm.expectRevert(Vault.InsufficientAllowance.selector);
        vault.deposit(100000);
        vm.stopPrank();
    }

    function testDepositInsufficientApprovalReverts() public {
        // Should revert if approved amount is less than deposit
        vm.startPrank(sinc);
        sinclair.approve(address(this), 100000);
        vm.expectRevert(Vault.InsufficientAllowance.selector);
        vault.deposit(10000000);
        vm.stopPrank();
    }

    function testDepositFailsIfTransferFromReturnsFalse() public {
        // Should revert if token’s transferFrom returns false
        
    }

    function testWithdrawSuccess() public approveAndDeposit{
        // Should withdraw deposited tokens successfully


    }

    function testWithdrawZeroReverts() public {
        // Should revert when withdrawal amount is zero
        vm.startPrank(sinc);
        vm.expectRevert(Vault.ZeroNotAllowed.selector);
        vault.withdraw(0);
        vm.stopPrank();

    }

    function testWithdrawMoreThanBalanceReverts() public approveAndDeposit{
        // Should revert when withdrawing more than deposited
        vm.startPrank(sinc);
        vm.expectRevert(Vault.InsufficientVaultBalance.selector);
        vault.withdraw(depositAmount + approveAmount);
        vm.stopPrank();
    }

    function testWithdrawFailsIfTransferReturnsFalse() public {
        // Should revert if token’s transfer returns false
    }

    

    function testMultipleDepositsAccumulateCorrectly() public {
        // Repeated deposits by one user should be cumulative
    }

    function testMultipleUsersTrackedIndependently() public {
        // Separate users can deposit/withdraw independently
    }

    
}
