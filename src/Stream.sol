// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.22;

import { ISablierLockup } from "@sablier/lockup/src/interfaces/ISablierLockup.sol";
import { LockupLinear }   from "@sablier/lockup/src/types/DataTypes.sol";

contract Stream {

    ISablierLockup public immutable LOCKUP;

    struct StreamIntent {
        address sender;
        address recipient;
        uint256 totalAmount;
        address token;
        bytes32 durationsHash; // keccak256(abi.encode(Duration[]))
        bool cancelable;
        bool transferable;
    }

    constructor(address _sablierLockup) {
        LOCKUP = ISablierLockup(_sablierLockup);
    }

    function createStream(
        StreamIntent           calldata streamIntent,
        bytes                  calldata intentSignature,
        LockupLinear.Durations calldata durations,
        uint256                validAfter,
        uint256                validBefore,
        bytes32                nonce,
        uint8                  v,
        bytes32                r,
        bytes32                s
    ) public returns (uint256 streamId) {
        return 0;
    }

}