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

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _token) {
        if (_token == address(0)) revert InvalidAddress();
        token = IERC20(_token);
    }

    // function approve(uint256 _amount) public {
    //     if (msg.sender == address(0)) revert InvalidAddress();
    //     if (_amount <= 0) revert ZeroNotAllowed();
    //     if(token.balanceOf(msg.sender) <= _amount) revert InsufficientFunds();

    //     token.approve(address(this), _amount);
    // }

    function deposit(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount == 0) revert ZeroNotAllowed();
        if (token.allowance(msg.sender, address(this)) < _amount) revert InsufficientAllowance();

        bool success = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "deposit failed");

        balances[msg.sender] += _amount;
        contractBalance += _amount;

        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();

        balances[msg.sender] -= _amount;
        contractBalance -= _amount;

        bool success = token.transfer(msg.sender, _amount);
        require(success, "Withdraw failed");

        emit Withdrawn(msg.sender, _amount);
    }
}
