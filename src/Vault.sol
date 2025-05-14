// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault Contract
 * @author Sinclare210 on github
 * @notice This contract allows users to deposit and withdraw a specific ERC20 token.
 * @dev Assumes the token follows the standard ERC20 interface and returns true on transfer/transferFrom.
 */
contract Vault {
    /**
     * @notice The ERC20 token accepted by the vault
     */
    IERC20 public immutable token;

    /**
     * @notice Tracks each user's deposited balance
     */
    mapping(address => uint256) public balances;

    /**
     * @notice Total tokens held in the vault
     */
    uint256 public contractBalance;

    /**
     * @notice Revert when a zero amount is passed to deposit or withdraw
     */
    error ZeroNotAllowed();

    /**
     * @notice Revert when the token allowance is insufficient for deposit
     */
    error InsufficientAllowance();

    /**
     * @notice Revert when a user attempts to withdraw more than their balance
     */
    error InsufficientVaultBalance();

    /**
     * @notice Emitted when a user successfully deposits tokens
     *  @param user The address of the user who deposited the token
     *  @param amount The amount of tokens deposited
     */
    event Deposited(address indexed user, uint256 amount);

    /**
     * @notice Emitted when a user successfully withdraws tokens
     *  @param user The address of the user who withdrew
     *  @param amount The amount of tokens withdrawn
     */
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @param _token The address of the ERC20 token accepted by the vault
     */
    constructor(address _token) {
        token = IERC20(_token);
    }

    /**
     * @notice Allows a user to deposit tokens into the vault
     *  @dev Requires prior approval via ERC20 `approve`
     *  @param _amount The number of tokens to deposit
     */
    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (token.allowance(msg.sender, address(this)) < _amount) revert InsufficientAllowance();

        bool success = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "deposit failed");

        balances[msg.sender] += _amount;
        contractBalance += _amount;

        emit Deposited(msg.sender, _amount);
    }

    /**
     * @notice Allows a user to withdraw their deposited tokens
     *  @param _amount The number of tokens to withdraw
     */
    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (balances[msg.sender] < _amount) revert InsufficientVaultBalance();

        balances[msg.sender] -= _amount;
        contractBalance -= _amount;

        bool success = token.transfer(msg.sender, _amount);

        /**
         * @notice take care of tokens that returns false when successful
         */
        require(success, "Withdraw failed");

        emit Withdrawn(msg.sender, _amount);
    }
}
