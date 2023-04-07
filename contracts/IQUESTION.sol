// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IQUESTION {
    struct MasterAnswer {
        string answerURL;
        bool isHelpful;
    }

    struct QuestionData {
        uint256 reward;
        uint256 expirationDate;
        bool isSolved;
    }

    event Minted(address indexed seeker, uint256 indexed tokenId);
    event Destroyed(address indexed seeker, uint256 indexed tokenId);

    //Only Seeker can call this function
    function extendExpirationDate(
        uint256 tokenId,
        uint256 newExpirationDate,
        string memory metadataId
    ) external;

    //Only Seeker can call this function
    function modifyReward(
        uint256 tokenId,
        uint256 newReward,
        string memory metadataId
    ) external;

    //Only Master can call this function
    function addAnswer(uint256 tokenId, string memory answerURL) external;

    //Only Seeker and Owner can call this function
    function getAnswers(
        uint256 tokenId
    ) external view returns (string[] memory answers);

    //Only Seeker can call this function
    function setSolved(
        uint256 tokenId,
        uint256 indexOfMaster,
        string memory metadataId
    ) external;

    // There will have a helper function to execute minting, so seekers don't need to pay gas fee
    function mintTo(
        uint256 reward,
        uint256 expirationDate,
        address seeker,
        string memory metadataId
    ) external;
}
