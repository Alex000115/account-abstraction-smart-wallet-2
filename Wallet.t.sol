// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./SmartWallet.sol";

contract SmartWalletTest is Test {
    SmartWallet wallet;
    address entryPoint = address(0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789);
    address owner = address(0x123);

    function setUp() public {
        wallet = new SmartWallet(entryPoint, owner);
    }

    function testOwnerIsSet() public {
        assertEq(wallet.owner(), owner);
    }

    function testFailNonEntryPointCall() public {
        vm.prank(owner);
        wallet.execute(address(0), 0, "");
    }
}
