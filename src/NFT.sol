// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { BytesLib } from "solidity-bytes-utils/BytesLib.sol";

contract NFT {
    uint256 public maxSupply = 5000;

    mapping(uint256 => bytes) public allSeedData;

    // size of a single packed seed entry
    uint8 public constant SEED_ENTRY_SIZE = 32;

    // size of a chunk of seed data stored in our allSeedData mapping
    uint256 public constant SEED_CHUNK_SIZE = 250;

    /// @notice sets all seed data for the project
    function setSeedData(uint8 index, bytes calldata _seedData) public {
        allSeedData[index] = _seedData;
    }

   /// @notice decode a packed seed and retrieve the attributes for a given id
    function getSeedById(uint256 id) public view returns (bytes32) {
        require(id < maxSupply, "ID_OUT_OF_RANGE");

        uint256 _seedDataIndex = getSeedDataIndex(id);
        bytes memory _seedData = allSeedData[_seedDataIndex];

        // calculate start index
        uint256 startIndex = getSeedStartIndex(id);

        // require that we have enough array index to extract a full seed
        require(_seedData.length >= startIndex + SEED_ENTRY_SIZE, "SEED_ARRAY_OUT_OF_BOUNDS");

        // extract relevant bytes from allSeedData array
        uint256 seedUint = BytesLib.toUint256(_seedData, startIndex);

        return bytes32(seedUint);
    }

    /// @notice helper to get the seed bytes index based upon a given token id
    function getSeedDataIndex(uint256 id) public view returns (uint256) {
        require(id < maxSupply, "ID_OUT_OF_RANGE");
        return id / SEED_CHUNK_SIZE;
        // if (id < 500) {
        //     return 0;
        // } else if (id < 1000) {
        //     return 1;
        // } else if (id < 1500) {
        //     return 2;
        // } else if (id < 2000) {
        //     return 3;
        // } else if (id < 2500) {
        //     return 4;
        // } else if (id < 3000) {
        //     return 5;
        // } else if (id < 3500) {
        //     return 6;
        // } else if (id < 4000) {
        //     return 7;
        // } else if (id < 4500) {
        //     return 8;
        // } else {
        //     return 9;
        // }
    }

    /// @notice helper to get the bytes array startIndex based upon the desired token id
    function getSeedStartIndex(uint256 id) public view returns (uint256) {
        require(id < maxSupply, "ID_OUT_OF_RANGE");
        uint256 _dataIndex = getSeedDataIndex(id);
        uint256 _seedPosition = id - (_dataIndex * SEED_CHUNK_SIZE);
        return _seedPosition * SEED_ENTRY_SIZE;
    } 
}
