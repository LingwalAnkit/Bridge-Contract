// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeBase is Ownable {
    constructor() Ownable(msg.sender) {}

    function Mint() public {}

    function Burn() public onlyOwner {}

    function depositeHappendonOtherSide() public {}
}
