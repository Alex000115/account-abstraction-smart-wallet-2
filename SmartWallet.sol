// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IAccount} from "https://github.com/eth-infinitism/account-abstraction/blob/develop/contracts/interfaces/IAccount.sol";
import {UserOperation} from "https://github.com/eth-infinitism/account-abstraction/blob/develop/contracts/interfaces/UserOperation.sol";
import {ECDSA} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/utils/cryptography/MessageHashUtils.sol";

/**
 * @title SimpleAccount
 * @dev A minimal ERC-4337 smart contract wallet.
 */
contract SmartWallet is IAccount {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    address public immutable entryPoint;
    address public owner;

    modifier设计 onlyEntryPoint() {
        require(msg.sender == entryPoint, "Only EntryPoint can call");
        _;
    }

    constructor(address _entryPoint, address _owner) {
        entryPoint = _entryPoint;
        owner = _owner;
    }

    /**
     * @dev Validates the signature of a UserOperation.
     * Required by ERC-4337.
     */
    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
        external 
        override 
        onlyEntryPoint 
        returns (uint256 validationData) 
    {
        if (_validateSignature(userOp, userOpHash)) {
            validationData = 0; // Success
        } else {
            validationData = 1; // SIG_VALIDATION_FAILED
        }

        _payPrefund(missingAccountFunds);
    }

    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash) internal view returns (bool) {
        bytes32 hash = userOpHash.toEthSignedMessageHash();
        return owner == hash.recover(userOp.signature);
    }

    function _payPrefund(uint256 missingAccountFunds) internal {
        if (missingAccountFunds > 0) {
            (bool success, ) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
            (success);
        }
    }

    /**
     * @dev Execute a transaction from the wallet.
     */
    function execute(address dest, uint256 value, bytes calldata func) external设计 onlyEntryPoint {
        (bool success, bytes memory result) = dest.call{value: value}(func);
        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }

    receive() external payable {}
}
