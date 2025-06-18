// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/BridgeEth.sol";
import "src/Xcoin.sol";


contract BridgeEthTest is Test {
    event Transfer(address indexed from , address indexed to , uint256 amount);
    BridgeEth public bridge;
    Xcoin public xcoin;

    function setUp() public {
        xcoin = new Xcoin();
        bridge = new BridgeEth(address(xcoin));
    }


    function test_deposite() public {
        xcoin.mint(0x3305C8D81dF4758cE122ABF04d36b1eF709cA7Ae, 100); // i minted 100 xcoins to the my address (0x3305C8D81dF4758cE122ABF04d36b1eF709cA7Ae my public key)
        vm.startPrank(0x3305C8D81dF4758cE122ABF04d36b1eF709cA7Ae);
        // startPrank is used to simulate the transaction from the address 0x3305C8D81dF4758cE122ABF04d36b1eF709cA7Ae
        xcoin.approve(address(bridge), 100);
        // approve is used to give the bridge contract permission to spend 100 xcoins on behalf of me
        assertEq(xcoin.balanceOf(0x3305C8D81dF4758cE122ABF04d36b1eF709cA7Ae), 0);
        assertEq(xcoin.balanceOf(address(bridge)), 100);
    }
}