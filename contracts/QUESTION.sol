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

    mapping(uint256 => address[]) private _masters;
    mapping(uint256 => address) private _seeker;
    mapping(uint256 => string) private _baseTokenMetadataId;
    mapping(uint256 => mapping(address => MasterAnswer)) private _masterAnswers;
    mapping(uint256 => QuestionData) public tokenIdtoQuestionData;

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

    // For extending the expiration date
    function extendExpirationDate(
        uint256 tokenId,
        uint256 newExpirationDate,
        string memory metadataId
    ) external onlyMinter {
        require(
            tokenIdtoQuestionData[tokenId].isSolved == false,
            "The question has been solved"
        );
        require(
            newExpirationDate > tokenIdtoQuestionData[tokenId].expirationDate,
            "New date must be later than the current date"
        );
        tokenIdtoQuestionData[tokenId].expirationDate = newExpirationDate;
        _updateMetadata(tokenId, metadataId);
    }

    function modifyReward(
        uint256 tokenId,
        uint256 newReward,
        string memory metadataId
    ) external onlyMinter {
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
        _updateMetadata(tokenId, metadataId);
    }

    // Record master's answers
    function addAnswer(
        uint256 tokenId,
        address master,
        string memory answerURL
    ) external onlyMinter {
        require(
            tokenIdtoQuestionData[tokenId].isSolved == false,
            "The question has been solved"
        );
        require(
            tokenIdtoQuestionData[tokenId].expirationDate > block.timestamp,
            "The question has expired"
        );
        require(
            bytes(_masterAnswers[tokenId][master].answerURL).length == 0,
            "You have already answered this question"
        );
        _masters[tokenId].push(master);
        _masterAnswers[tokenId][master].answerURL = answerURL;
    }

    function checkAnswer(
        uint256 tokenId
    ) external view returns (MasterAnswer memory answer) {
        require(
            _msgSender() != _seeker[tokenId] &&
                _msgSender() != owner() &&
                _msgSender() != minter &&
                _msgSender() != admin,
            "Only the master can access this function."
        );
        require(
            bytes(_masterAnswers[tokenId][_msgSender()].answerURL).length > 0,
            "You have not answered this question."
        );
        answer = _masterAnswers[tokenId][_msgSender()];
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
    ) external onlyMinter {
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
        ERC20(0x75983C3DBbe1E4B614Ae2E8ab484fEFd2bb19E04).transfer(
            _masters[tokenId][indexOfMaster],
            tokenIdtoQuestionData[tokenId].reward
        );
        _updateMetadata(tokenId, metadataId);
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
        _baseTokenMetadataId[_tokenId] = metadataId;
        _safeMint(_msgSender(), _tokenId);
        _transfer(_msgSender(), seeker, _tokenId);
        emit Minted(_msgSender(), _tokenId);
        _tokenId += 1;
    }

    function _updateMetadata(
        uint256 tokenId,
        string memory metadataId
    ) internal {
        require(
            bytes(metadataId).length > 0,
            "The metadataId must not be empty"
        );
        _baseTokenMetadataId[tokenId] = metadataId;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://arweave.net/";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();

        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(baseURI, _baseTokenMetadataId[tokenId])
                )
                : "";
    }
}
