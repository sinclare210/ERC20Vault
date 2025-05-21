// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault Contract
 * @author Sinclare210
 * @notice This contract allows users to deposit and withdraw a specific ERC20 token,
 * even if the token does not return a boolean value on transfer (e.g., USDT).
 * @dev Uses low-level `call` to handle non-compliant ERC20 tokens.
 */
contract Vault {
    /// @notice The ERC20 token accepted by the vault (address stored to support low-level calls)
    address public immutable token;

    /// @notice Tracks each user's deposited balance
    mapping(address => uint256) public balances;

    /// @notice Total tokens held in the vault
    uint256 public contractBalance;

    /// @notice Revert when a zero amount is passed to deposit or withdraw
    error ZeroNotAllowed();

    /// @notice Revert when a user tries to withdraw more than their balance
    error InsufficientVaultBalance();

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _token) {
        token = _token;
    }

    function safeTransfer(address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transfer.selector, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    function safeTransferFrom(address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();

        safeTransferFrom(msg.sender, address(this), _amount);

        balances[msg.sender] += _amount;
        contractBalance += _amount;

        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();

        balances[msg.sender] -= _amount;
        contractBalance -= _amount;

        safeTransfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }
}
