// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract AskQuestion {
    address public owner;
    address public seeker;

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address _owner) public {
        require(msg.sender == owner, "Only owner can set owner");
        owner = _owner;
    }
}
