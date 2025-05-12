// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {

    IERC20 public immutable token;

    constructor (address _token){
        token = IERC20(_token);
    }

    function allowance() internal view {
        token.allowance(msg.sender, address(this));

    }

    function approve (uint256 _amount) internal {
        token.approve(msg.sender, _amount);
    }

    funtion 





}
