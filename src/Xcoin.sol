// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Xcoin is ERC20, Ownable {
    constructor() ERC20("Xcoin", "XCo") Ownable(msg.sender) {   
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address to, uint amount) public onlyOwner {
        _burn(to, amount);
    }
    
}
