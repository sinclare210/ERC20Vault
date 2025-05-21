// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault Contract
 * @author Sinclare210
 * @notice This contract allows users to deposit and withdraw a specific ERC20 token,
 *         including non-compliant tokens like USDT that don't return booleans.
 * @dev Uses low-level `call` to handle token transfers for broader compatibility.
 */
contract Vault {
    /// @notice The ERC20 token accepted by the vault
    /// @dev Stored as an address to allow low-level call operations
    address public immutable token;

    /// @notice Tracks each user's deposited balance
    mapping(address => uint256) public balances;

    /// @notice Total tokens held in the vault
    uint256 public contractBalance;

    /// @notice Reverts if `_amount` is zero
    error ZeroNotAllowed();

    /// @notice Reverts if the caller tries to withdraw more than their deposited balance
    error InsufficientVaultBalance();

    /**
     * @notice Emitted when a user deposits tokens into the vault
     * @param user The address of the depositor
     * @param amount The amount of tokens deposited
     */
    event Deposited(address indexed user, uint256 amount);

    /**
     * @notice Emitted when a user withdraws tokens from the vault
     * @param user The address of the withdrawer
     * @param amount The amount of tokens withdrawn
     */
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @notice Initializes the vault with the specified token
     * @param _token The address of the ERC20 token to be accepted
     */
    constructor(address _token) {
        token = _token;
    }

    /**
     * @notice Performs a safe transfer of tokens from this contract to a recipient
     * @dev Uses low-level call to support non-standard ERC20 tokens
     * @param to The recipient address
     * @param amount The amount of tokens to transfer
     */
    function safeTransfer(address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transfer.selector, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    /**
     * @notice Performs a safe transfer of tokens from a user to a recipient
     * @dev Uses low-level call to support non-standard ERC20 tokens
     * @param from The address to transfer tokens from
     * @param to The address to transfer tokens to
     * @param amount The amount of tokens to transfer
     */
    function safeTransferFrom(address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    /**
     * @notice Allows a user to deposit tokens into the vault
     * @dev The user must first approve this contract to spend their tokens
     * @param _amount The amount of tokens to deposit
     * @custom:reverts ZeroNotAllowed if `_amount` is 0
     * @custom:emits Deposited event
     */
    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();

        safeTransferFrom(msg.sender, address(this), _amount);

        balances[msg.sender] += _amount;
        contractBalance += _amount;

        emit Deposited(msg.sender, _amount);
    }

    /**
     * @notice Allows a user to withdraw their tokens from the vault
     * @param _amount The amount of tokens to withdraw
     * @custom:reverts ZeroNotAllowed if `_amount` is 0
     * @custom:reverts InsufficientVaultBalance if user tries to withdraw more than deposited
     * @custom:emits Withdrawn event
     */
    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();

        balances[msg.sender] -= _amount;
        contractBalance -= _amount;

        safeTransfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }
}
