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

    // There will have a helper function to execute this function, so seekers don't need to pay gas fee
    function extendExpirationDate(
        uint256 tokenId,
        uint256 newExpirationDate,
        string memory metadataId
    ) external;

    // There will have a helper function to execute this function, so seekers don't need to pay gas fee
    function modifyReward(
        uint256 tokenId,
        uint256 newReward,
        string memory metadataId
    ) external;

    // There will have a helper function to execute this function, so master don't need to pay gas fee
    function addAnswer(uint256 tokenId, address master, string memory answerURL) external;

    //For Master to check it's answer
    function checkAnswer(
        uint256 tokenId
    ) external view returns (MasterAnswer memory answer);

    //Only Seeker and Owner can call this function
    function getAnswers(
        uint256 tokenId
    ) external view returns (string[] memory answers);

    // There will have a helper function to execute this function, so seekers don't need to pay gas fee
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
