// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    mapping(address => uint256) balances;

    uint256 contractBalance;

    error InvalidAddress();
    error ZeroNotAllowed();
    error InsufficientFunds();

    constructor(address _token) {
        token = IERC20(_token);
    }

    function approve(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount <= 0) revert ZeroNotAllowed();
        if(token.balanceOf(msg.sender) <= _amount) revert InsufficientFunds();
        
        token.approve(address(this), _amount);
    }

    function deposit(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount <= 0) revert ZeroNotAllowed();
        if(token.allowance(msg.sender, address(this)) <= _amount) revert InsufficientFunds();

        (bool success) = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "Transfer Failed");
        balances[msg.sender] = balances[msg.sender] + _amount;
        contractBalance = contractBalance + _amount;
    }

    function withdraw(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount <= 0) revert ZeroNotAllowed();
        if(balances[msg.sender] <= _amount) revert InsufficientFunds();

        balances[msg.sender] = balances[msg.sender] - _amount;

        contractBalance = contractBalance - _amount;

        (bool success) = token.transfer(msg.sender, _amount);

        require(success, "Failed");
    }
}
