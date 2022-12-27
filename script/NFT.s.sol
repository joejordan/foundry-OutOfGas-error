// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";

// import { FoundryRandom } from "foundry-random/FoundryRandom.sol";
// import { BytesLib } from "solidity-bytes-utils/BytesLib.sol";

import { NFT } from "src/NFT.sol";


/// To run the Foundry out-of-gas demo script:
///
/// 1) start up anvil with an absurdly high gas limit: anvil --gas-limit 3000000000999999999
/// 2) Execute following script:
/// forge script script/HedgeNFT.s.sol:HedgeNFTScript --rpc-url "http://127.0.0.1:8545" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast --slow -vvv
///
/// @dev you can tweak the maxSupply and SEED_CHUNK_SIZE vars in 
/// NFT.sol to adust how quickly we hit an EVM OutOfGas error.
///
/// per my experiments, maxSupply = 5000 and SEED_CHUNK_SIZE = 250 works!;
/// maxSupply = 5000 and SEED_CHUNK_SIZE = 500 gets most of the way through but errors
/// maxSupply = 5000 and SEED_CHUNK_SIZE = 1000 gets less than half way through before errors

contract NFTScript is Script { // , FoundryRandom {
    NFT nft;

    function run() public {
        bytes memory _seedData;

        // deploy NFT on-chain
        vm.startBroadcast();
        nft = new NFT();
        vm.stopBroadcast();

        /// @dev it does not seem to matter where we put vm.pauseGasMetering(), 
        /// attempting to seed our NFT with 5000 seed at 500 to 1000+ entries at a time is always failing.
        vm.pauseGasMetering();

        // calculate number of loops to hit our maxSupply
        uint256 seedChunks = nft.maxSupply() / nft.SEED_CHUNK_SIZE();
        console2.log("SEED CHUNKS:", seedChunks);

        for (uint8 i = 0; i < seedChunks; i++) {
            // generate seed data
            _seedData = generateSeed(nft.SEED_CHUNK_SIZE());

            // set generated seed data to chain
            vm.startBroadcast();
            nft.setSeedData(i, _seedData);
            vm.stopBroadcast();
        }

        // vm.startBroadcast();
        // console2.log("LAST SEED ON-CHAIN:");
        // console2.logBytes32(nft.getSeedById(nft.maxSupply() - 1));
        // vm.stopBroadcast();
    }

    /// @notice generate a random collection of seed attributes
    /// @dev NOTE: For higher numberToGenerate values, this may take a while.
    /// @dev NOTE 2: Foundry hits gas limitations at just after 1000 seed generated.
    function generateSeed(uint256 numberToGenerate) public pure returns (bytes memory) {
        bytes memory seedData;

        // Generate seed collection
        for (uint256 i = 0; i < numberToGenerate; i++) {
            // seedData = BytesLib.concat(seedData, bytes.concat(randomBytes32()));
            seedData = bytes.concat(seedData, bytes32(0xfc0d99e40167184a9631f233e783e033fad56524cede94e276af1bb3037aeb53));
        }

        // print out the generated seedData
        // console2.logBytes(seedData);

        return seedData;

    }
}
