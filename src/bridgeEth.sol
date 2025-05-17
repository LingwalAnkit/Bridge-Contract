// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract BridgeEth is Ownable{

    uint256 public balance;
    address public tokenaddress;
    event Deposite(address indexed depositor , uint amount); // for logging 
    mapping(address => uint256) public pendingBalance;

    constructor(address _tokenaddress) Ownable(msg.sender){
        tokenaddress = _tokenaddress;
    }
    function deposite(IERC20 _tokenaddress , uint256 amount) public{
        require(address(_tokenaddress) == tokenaddress);
        // Makes sure the user is depositing the correct token (the one your contract is set up to accept).
        require(_tokenaddress.allowance(msg.sender , address(this)) >= amount);
        // tranfer takes two parameters owner and spender
        require(_tokenaddress.transferFrom(msg.sender , address(this), amount));
        // parameters from to and value and it returns boolean value
        emit Deposite(msg.sender, amount);
    }

    function Withdraw(IERC20 _tokenaddress , uint256 amount) public{
        require(pendingBalance[msg.sender] >= amount);
        pendingBalance[msg.sender] -= amount;
        _tokenaddress.transfer(msg.sender , amount);
    }

    function BurnedonOtherSide(address useraccount , uint256 amount) public {
        pendingBalance[useraccount] += amount;
    }

}