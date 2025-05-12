// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    mapping(address => uint256) public balances;
    uint256 public contractBalance;

    error InvalidAddress();
    error ZeroNotAllowed();
    error InsufficientAllowance();
    error InsufficientVaultBalance();

    constructor(address _token) {
        if (_token == address(0)) revert InvalidAddress();
        token = IERC20(_token);
    }

    function deposit(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount == 0) revert ZeroNotAllowed();
        if (token.balanceOf(msg.sender) < _amount) revert InsufficientAllowance();

        bool success = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "Transfer failed");

        balances[msg.sender] += _amount;
        contractBalance += _amount;
    }

    function withdraw(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();

        balances[msg.sender] -= _amount;
        contractBalance -= _amount;

        bool success = token.transfer(msg.sender, _amount);
        require(success, "Withdraw transfer failed");
    }
}
