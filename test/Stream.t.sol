// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.22;

import { Test }                 from "forge-std/Test.sol";
import { console2 }             from "forge-std/console2.sol";
import { Stream, StreamIntent } from "../src/Stream.sol";
import { Params }               from "../libraries/Params.sol";

contract StreamTest is Test {

    Stream public stream;

    function setUp() public {
        stream = new Stream(Params.BASESEPOLIA_SABLIER_LOCKUP);
        console2.logUint(block.number);
    }

    function test_createStream() public {
        // console.log(block.number);
        uint b = 12;
        // console.log(b);
        uint a = 12;
    }
}