// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/NFT.sol";

contract CounterTest is Test {
    NFT public nft;

    function setUp() public {
        nft = new NFT();
    }
}
