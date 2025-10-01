// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.22;

import { Test }                 from "forge-std/Test.sol";
import { console2 }             from "forge-std/console2.sol";
import { Stream, StreamIntent } from "../src/Stream.sol";
import { Params }               from "../libraries/Params.sol";
import { LockupLinear }         from "@sablier/lockup/src/types/DataTypes.sol";
import { IERC20 }               from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StreamTest is Test {

    Stream public stream;
    address public sender;
    uint256 public senderPrivateKey = 0xA11CE;

    function setUp() public {
        stream = new Stream(Params.SEPOLIA_SABLIER_LOCKUP);
        sender = vm.addr(senderPrivateKey);
    }

    function test_createStream() public {
        LockupLinear.Durations memory durations = LockupLinear.Durations({ cliff: 0, total: 1000 });

        StreamIntent memory si = StreamIntent({
            sender: sender,
            recipient: address(0xBEEF),
            totalAmount: 1000000000000000000,
            token: Params.SEPOLIA_USDC,
            durationsHash: keccak256(abi.encode(durations)),
            cancelable: true,
            transferable: true,
            validBefore: block.timestamp + 1000,
            validAfter: block.timestamp,
            nonce: keccak256("test-nonce-1")
        });

        // Sign the intent
        bytes32 digest = stream.hashStreamIntent(si);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(senderPrivateKey, digest);
        bytes memory intentSignature = abi.encodePacked(r, s, v);

        // Give sender tokens and approve Stream contract
        deal(si.token, sender, si.totalAmount);
        vm.prank(sender);
        IERC20(si.token).approve(address(stream), si.totalAmount);

        // Create stream
        stream.createStream(si, intentSignature, durations);
    }
}