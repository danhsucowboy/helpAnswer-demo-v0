// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./IQUESTION.sol";

contract QUESITON is Ownable, ERC721, IQUESTION {
    uint256 private _tokenId;
    address public minter;
    address public admin;
    string private _baseTokenMetadataId;

    mapping(uint256 => address[]) private _masters;
    mapping(uint256 => address) private _seeker;
    mapping(uint256 => mapping(address => MasterAnswer)) private _masterAnswers;
    mapping(uint256 => QuestionData) public tokenIdtoQuestionData;

    //Suppose the master address isn't the seeker or the owner
    modifier onlyMaster(uint256 tokenId) {
        require(
            _msgSender() != _seeker[tokenId] &&
                _msgSender() != owner() &&
                _msgSender() != minter &&
                _msgSender() != admin,
            "Only a master can access this function."
        );
        _;
    }

    modifier onlySeeker(uint256 tokenId) {
        require(
            _msgSender() == _seeker[tokenId],
            "Only the seeker can access this function."
        );
        _;
    }

    modifier onlyMinter() {
        require(
            _msgSender() == minter,
            "Only the minter can access this function."
        );
        _;
    }

    constructor() ERC721("Question", "QUES") {
        admin = _msgSender();
        _tokenId = 0;
    }

    function setMinter(address _minter) public {
        require(
            _msgSender() == admin,
            "Only the admin can access this function."
        );
        minter = _minter;
    }

    // There will have a helper function to execute minting, so seekers don't need to pay gas fee
    function mintTo(
        uint256 reward,
        uint256 expirationDate,
        address seeker,
        string memory metadataId
    ) external onlyMinter {
        require(
            bytes(metadataId).length > 0,
            "The metadataId must not be empty"
        );
        require(
            reward > 0 && reward <= 5,
            "The reward must be between 1 and 5"
        );
        require(
            expirationDate > block.timestamp,
            "New date must be later than the current date"
        );
        tokenIdtoQuestionData[_tokenId].reward = reward;
        tokenIdtoQuestionData[_tokenId].expirationDate = expirationDate;
        _seeker[_tokenId] = seeker;
        _baseTokenMetadataId = metadataId;
        _safeMint(_msgSender(), _tokenId);
        _transfer(_msgSender(), seeker, _tokenId);
        emit Minted(_msgSender(), _tokenId);
        _tokenId += 1;
    }

    // For extending the expiration date
    function extendExpirationDate(
        uint256 tokenId,
        uint256 newExpirationDate,
        string memory metadataId
    ) external onlySeeker(tokenId) {
        require(
            tokenIdtoQuestionData[tokenId].isSolved == false,
            "The question has been solved"
        );
        require(
            newExpirationDate > tokenIdtoQuestionData[tokenId].expirationDate,
            "New date must be later than the current date"
        );
        tokenIdtoQuestionData[tokenId].expirationDate = newExpirationDate;
        _updateMetadata(metadataId);
    }

    function modifyReward(
        uint256 tokenId,
        uint256 newReward,
        string memory metadataId
    ) external onlySeeker(tokenId) {
        require(
            tokenIdtoQuestionData[tokenId].isSolved == false,
            "The question has been solved"
        );
        require(
            tokenIdtoQuestionData[tokenId].expirationDate > block.timestamp,
            "The question has expired"
        );
        require(
            newReward > 0 && newReward <= 5,
            "The reward must be between 1 and 5"
        );
        tokenIdtoQuestionData[tokenId].reward = newReward;
        _updateMetadata(metadataId);
    }

    // Record master's answers
    function addAnswer(
        uint256 tokenId,
        string memory answerURL
    ) external onlyMaster(tokenId) {
        require(
            tokenIdtoQuestionData[tokenId].isSolved == false,
            "The question has been solved"
        );
        require(
            tokenIdtoQuestionData[tokenId].expirationDate > block.timestamp,
            "The question has expired"
        );
        require(
            bytes(_masterAnswers[tokenId][_msgSender()].answerURL).length == 0,
            "You have already answered this question"
        );
        _masters[tokenId].push(_msgSender());
        _masterAnswers[tokenId][_msgSender()].answerURL = answerURL;
    }

    function getAnswers(
        uint256 tokenId
    ) external view returns (string[] memory answers) {
        require(
            _msgSender() == _seeker[tokenId] || _msgSender() == owner(),
            "Only the seeker and owner can access this function."
        );
        for (uint256 i = 0; i < _masters[tokenId].length; i++) {
            answers[i] = _masterAnswers[tokenId][_masters[tokenId][i]]
                .answerURL;
        }
    }

    function setSolved(
        uint256 tokenId,
        uint256 indexOfMaster,
        string memory metadataId
    ) external onlySeeker(tokenId) {
        require(
            tokenIdtoQuestionData[tokenId].isSolved == false,
            "The question has been solved"
        );
        require(
            tokenIdtoQuestionData[tokenId].expirationDate > block.timestamp,
            "The question has expired"
        );
        tokenIdtoQuestionData[tokenId].isSolved = true;
        _masterAnswers[tokenId][_masters[tokenId][indexOfMaster]]
            .isHelpful = true;
        // ERC20("thankyoutoken address").transfer(
        //     _masters[tokenId][indexOfMaster],
        //     tokenIdtoQuestionData[tokenId].reward
        // );
        _updateMetadata(metadataId);
    }

    function _updateMetadata(string memory metadataId) internal {
        require(
            bytes(metadataId).length > 0,
            "The metadataId must not be empty"
        );
        _baseTokenMetadataId = metadataId;
    }

    function _baseURI() internal view override returns (string memory) {
        return
            string(
                abi.encodePacked("https://arweave.net/", _baseTokenMetadataId)
            );
    }
}
