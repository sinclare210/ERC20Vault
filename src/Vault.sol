// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {

    IERC20 public immutable token;

    mapping (address => uint256) balances;

    uint256 contractBalance;

    constructor (address _token){
        token = IERC20(_token);
    }

    

    function approve (uint256 _amount) public {
        token.approve(address(this), _amount);
    }

    function deposit (uint256 _amount) public {
        
        (bool success) = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "Transfer Failed");
        balances[msg.sender] = balances[msg.sender] + _amount;
        contractBalance = contractBalance + _amount;
    }

    function withdraw (uint256 _amount) public {
        balances[msg.sender] = balances[msg.sender] - _amount;
        contractBalance = contractBalance - _amount;
        (bool success) = token.transfer(msg.sender, _amount);
        require (success, "Failed");

    }






}
