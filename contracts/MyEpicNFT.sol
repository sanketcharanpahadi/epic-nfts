// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint public maxNoOfNFTs = 15;
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "CHAOS",
        "FUNNY",
        "HAPPY",
        "SUPERMAN",
        "NARUTO",
        "CLEAN"
    ];
    string[] secondWords = [
        "IS",
        "KITCHEN",
        "BALD",
        "BATMAN",
        "ANIME",
        "CARTOON"
    ];
    string[] thirdWords = [
        "LADDER",
        "MOUTH",
        "KNIFE",
        "POOR",
        "CUCUMBER",
        "ROCKET"
    ];
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is Sanket's NFT Contract. Yay!");
    }

    function pickRandomWord(
        uint256 tokenId,
        string[] memory arr
    ) public pure returns (string memory) {
        uint256 rand = random(
            string(abi.encodePacked("RANDOM_WORD", Strings.toString(tokenId)))
        );
        rand = rand % arr.length;
        return arr[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        require(
            newItemId < maxNoOfNFTs - 1,
            "ALL NFTs have already been mined."
        );

        string memory first = pickRandomWord(newItemId, firstWords);
        string memory second = pickRandomWord(newItemId, secondWords);
        string memory third = pickRandomWord(newItemId, thirdWords);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, first, second, third, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        console.log("\n---------------------------------------------------");
        console.log(finalSvg);
        console.log("---------------------------------\n");

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
