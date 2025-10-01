// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.22;

import { Test }   from "forge-std/Test.sol";
import { Stream } from "../src/Stream.sol";
import { Params } from "../libraries/Params.sol";

contract StreamTest is Test {

    Stream public stream;

    function setUp() public {
        stream = new Stream(Params.BASESEPOLIA_SABLIER_LOCKUP);
    }

    function test_createStream() public {
        return;
    }
}