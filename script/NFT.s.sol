// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import { FoundryRandom } from "foundry-random/FoundryRandom.sol";

import { BytesLib } from "solidity-bytes-utils/BytesLib.sol";

import { NFT } from "src/NFT.sol";


/// To run the Foundry out-of-gas demo script:
///
/// 1) start up anvil
/// 2) Execute following script:
/// forge script script/HedgeNFT.s.sol:HedgeNFTScript --rpc-url "http://127.0.0.1:8545" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast --slow -vvv
contract NFTScript is Script, FoundryRandom {
    NFT nft;

    function run() public {

        // deploy NFT on-chain
        vm.startBroadcast();
        nft = new NFT();
        vm.stopBroadcast();

        vm.pauseGasMetering();

        for (uint8 i = 0; i < 5; i++) {
            vm.startBroadcast();
            nft.setGenomeData(i, generateSeed(100));
            vm.stopBroadcast();
        }
    }

    // function setSeedData() public {
    //     uint256 maxSupply = nft.maxSupply();
    //     console2.log("HEREEEE");
    //     for (uint256 i = 0; i < maxSupply; i++) {
    //         nft.seedNFT(i, randomBytes32());
    //     }
    // }

    /// @notice generate a random collection of genome attributes
    /// @dev NOTE: For higher numberToGenerate values, this may take a while.
    /// @dev NOTE 2: Foundry hits gas limitations at just after 1000 genome generated. 
    /// See pending fix: https://github.com/foundry-rs/foundry/pull/3906
    function generateSeed(uint256 numberToGenerate) public returns (bytes memory) {
        bytes memory seedData;

        // Generate genome collection
        for (uint256 i = 0; i < numberToGenerate; i++) {
            // seedData = abi.encode(seedData, randomBytes32());
            // seedData = 
            seedData = BytesLib.concat(seedData, bytes.concat(randomBytes32()));
        }

        // print out the generated seedData
        console2.logBytes(seedData);

        return seedData;

    }
}
