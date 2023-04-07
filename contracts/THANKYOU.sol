// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract THANKYOU is ERC20 {
   
    constructor() ERC20("THANKYOU", "TY") {
        _mint(msg.sender, 10000000 ether);
    }

}