// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeEth is Ownable {
    uint256 public balance;
    address public tokenaddress;
    event Deposite(address indexed depositor, uint amount); // for logging

    // Pending balance holds the amount that the user have locked in a smart contract
    mapping(address => uint256) public pendingBalance;

    // Constructor here expects the xcoin address when deployed
    constructor(address _tokenaddress) Ownable(msg.sender) {
        tokenaddress = _tokenaddress;
    }

    // IERC20 is the interface of ERC20 contract
    function Lock(IERC20 _tokenaddress, uint256 amount) public {
        // Checks if the address is correct
        require(address(_tokenaddress) == tokenaddress);

        // Approve to spend atleast amount (if i have 200 token to lock but i only approve 150 fails , but if i 200 token to lock approvinf >= 200 will work)
        require(_tokenaddress.allowance(msg.sender, address(this)) >= amount);

        // TransferFrom
        require(_tokenaddress.transferFrom(msg.sender, address(this), amount));

        // Event
        emit Deposite(msg.sender, amount);
    }

    function Unlock(IERC20 _tokenaddress, uint256 amount) public {
        require(address(_tokenaddress) == tokenaddress);
        require(pendingBalance[msg.sender] >= amount);
        pendingBalance[msg.sender] -= amount;
        _tokenaddress.transfer(msg.sender, amount);
    }

    function BurnedonOtherSide(address useraccount, uint256 amount) public {
        pendingBalance[useraccount] += amount;
        // when amount wrappedXcoins get burned on the other side amount get added to the pending balance
    }
}
