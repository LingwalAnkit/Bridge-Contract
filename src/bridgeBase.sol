// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Interface with correct spelling and syntax
interface IBUSDT is IERC20 {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
}

contract BridgeBase is Ownable {
    uint256 public amount;
    address public tokenAddress;

    event Burn(address indexed burner, uint256 amount);
    mapping(address => uint256) public pendingBalance;

    constructor(address _tokenaddress) Ownable(msg.sender) {
        tokenAddress = _tokenaddress;
    }

    function mint(IBUSDT _tokenAddress, uint256 amount) public {
        require(
            address(_tokenAddress) == tokenAddress,
            "Invalid token address"
        );
        require(
            pendingBalance[msg.sender] >= amount,
            "Insufficient pending balance"
        );
        pendingBalance[msg.sender] -= amount;
        _tokenAddress.mint(msg.sender, amount);
    }

    function burn(IBUSDT _tokenAddress, uint256 amount) public {
        require(
            address(_tokenAddress) == tokenAddress,
            "Invalid token address"
        );
        _tokenAddress.burn(msg.sender, amount);
        emit Burn(msg.sender, amount);
    }

    function depositeHappendonOtherSide(
        address userAccount,
        uint256 amount
    ) public onlyOwner {
        pendingBalance[userAccount] += amount;
    }
}
