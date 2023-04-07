// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MASTER is ERC721 {
    
    constructor() ERC721("MASTER", "MST") {
        _mint(msg.sender, 10000000 ether);
    }

}