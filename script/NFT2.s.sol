// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import { FoundryRandom } from "foundry-random/FoundryRandom.sol";

import { BytesLib } from "solidity-bytes-utils/BytesLib.sol";

import { NFT2 } from "src/NFT2.sol";


/// To run the Foundry out-of-gas demo script:
///
/// 1) start up anvil
/// 2) Execute following script:
/// forge script script/HedgeNFT.s.sol:HedgeNFTScript --rpc-url "http://127.0.0.1:8545" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast --slow -vvv
contract NFT2Script is Script, FoundryRandom {
    NFT2 nft;

    function run() public {
        bytes memory _seedData;

        
        vm.startBroadcast();

        // deploy NFT on-chain
        nft = new NFT2();


        vm.pauseGasMetering();

        for (uint256 i = 0; i < 5000; i++) {
            _seedData = abi.encodePacked(bytes32(randomBytes32()));
            nft.setSeedData(_seedData);
        }

        console2.logBytes32(bytes32(nft.getSeedData(4999)));

        vm.stopBroadcast();
    }
}
