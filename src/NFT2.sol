// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import { BytesLib } from "solidity-bytes-utils/BytesLib.sol";

contract NFT2 {
    uint256 public maxSupply = 5000;

    bytes public seedArray;

    // size of a single packed genome entry
    uint8 public constant SEED_SIZE = 32;


    /// @notice sets all genome data for the project
    function setSeedData(bytes calldata _seedData) public {
        console2.logBytes(_seedData);
        seedArray = bytes.concat(seedArray, _seedData);

    }

    function getSeedData(uint256 tokenId) public view returns (uint256) {
        uint256 startIndex = tokenId * SEED_SIZE;
        require(seedArray.length >= startIndex + SEED_SIZE, "SEED_ARRAY_OUT_OF_BOUNDS");

        bytes memory seedData = BytesLib.slice(seedArray, startIndex, SEED_SIZE);

        return BytesLib.toUint256(seedData, 0);
    }
}
