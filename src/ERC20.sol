// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Sinclair is ERC20 {
    constructor(address recipient) ERC20("Sinclair", "SIN")  {
        _mint(recipient, 100000000000 * 10 ** decimals());
    }

    function unRestrictedMint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }

    function approveContract(address spender, uint256 amount) public {
        approve(spender, amount);
    }

}
