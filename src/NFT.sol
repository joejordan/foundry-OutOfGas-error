// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract NFT {
    uint256 public maxSupply = 500;
    // mapping(uint256 => bytes32) public randomSeed;

    mapping(uint8 => bytes) public allGenomeData;

    // size of a single packed genome entry
    uint8 public constant GENOME_SIZE = 32;

    // function seedNFT(uint256 index, bytes32 randomData) public {
    //     randomSeed[index] = randomData;
    // }

    // function getSeedData(uint256 index) public view returns (bytes32) {
    //     return randomSeed[index];
    // }
    /// @notice sets all genome data for the project
    /// @dev this is for demo purposes only; this function would need to be secured in production
    function setGenomeData(uint8 index, bytes calldata _genomeData) public {
        allGenomeData[index] = _genomeData;
    }
}
