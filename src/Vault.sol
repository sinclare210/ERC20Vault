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

    /**
     * @notice Emitted when a user successfully deposits tokens
     * @param user The address of the user who deposited
     * @param amount The amount of tokens deposited
     */
    event Deposited(address indexed user, uint256 amount);

    /**
     * @notice Emitted when a user successfully withdraws tokens
     * @param user The address of the user who withdrew
     * @param amount The amount of tokens withdrawn
     */
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @param _token The address of the ERC20 token to be used by the vault
     */
    constructor(address _token) {
        token = _token;
    }

    /**
     * @notice Safely transfers tokens from this contract to a recipient
     * @dev Uses low-level call to support non-compliant ERC20 tokens
     * @param to The recipient address
     * @param amount The amount of tokens to transfer
     */
    function safeTransfer(address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    /**
     * @notice Safely transfers tokens from a user to a recipient (usually the contract)
     * @dev Uses low-level call to support non-compliant ERC20 tokens
     * @param from The address from which tokens are transferred
     * @param to The address to which tokens are transferred
     * @param amount The amount of tokens to transfer
     */
    function safeTransferFrom(address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    /**
     * @notice Allows a user to deposit tokens into the vault
     * @dev The user must first call `approve` on the token contract
     * @param _amount The number of tokens to deposit
     * Emits a {Deposited} event.
     * Reverts with {ZeroNotAllowed} if `_amount` is 0.
     */
    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();

        safeTransferFrom(msg.sender, address(this), _amount);

        balances[msg.sender] += _amount;
        contractBalance += _amount;

        emit Deposited(msg.sender, _amount);
    }

    /**
     * @notice Allows a user to withdraw their deposited tokens
     * @param _amount The number of tokens to withdraw
     * Emits a {Withdrawn} event.
     * Reverts with {ZeroNotAllowed} if `_amount` is 0.
     * Reverts with {InsufficientVaultBalance} if balance is insufficient.
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
