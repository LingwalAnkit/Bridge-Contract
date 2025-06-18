// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockXcoin {
    address private xcoinAddress;
    mapping(address => uint256) public pendingBalance;
    // maps the address of the user to the amount they have deposited

    constructor(address _xcoin) {
        xcoinAddress = _xcoin;
    }

    function Deposite(uint256 _amount) public {
        require(
            IERC20(xcoinAddress).allowance(msg.sender, address(this)) >=
                _amount,
            "Insufficient allowance"
        );
        IERC20(xcoinAddress).transferFrom(msg.sender, address(this), _amount);
        pendingBalance[msg.sender] += _amount;
        // maps the address of the user to the amount they have deposited
    }

    function Withdraw() public {
        uint256 remainingAmount = pendingBalance[msg.sender];
        IERC20(xcoinAddress).transfer(msg.sender, remainingAmount);
        pendingBalance[msg.sender] = 0;
    }
}
