// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.22;

import { ISablierLockup }               from "@sablier/lockup/src/interfaces/ISablierLockup.sol";
import { Broker, Lockup, LockupLinear } from "@sablier/lockup/src/types/DataTypes.sol";
import { ud60x18 }                      from "@prb/math/src/UD60x18.sol";
import { IERC20 }                       from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC3009 }                     from "./IERC3009.sol";

contract Stream {

    ISablierLockup public immutable LOCKUP;

    struct StreamIntent {
        address sender;
        address recipient;
        uint256 totalAmount;
        address token;
        bytes32 durationsHash; // keccak256(abi.encode(Duration[]))
        bool    cancelable;
        bool    transferable;
        uint256 validBefore;
        uint256 validAfter;
    }

    constructor(address _sablierLockup) {
        LOCKUP = ISablierLockup(_sablierLockup);
    }

    function createStream(
        StreamIntent           calldata si,              // stream intent
        bytes                  calldata intentSignature,
        LockupLinear.Durations calldata durations,
        uint256                validAfter,
        uint256                validBefore,
        bytes32                nonce,
        uint8                  v,
        bytes32                r,
        bytes32                s
    ) public returns (uint256 streamId) {
        require(block.timestamp            <  si.validBefore);
        require(si.durationsHash == keccak256(abi.encode(durations)));
        require(si.totalAmount   > 0);

        IERC3009(si.token).transferWithAuthorization(
            si.sender, 
            address(this), 
            si.totalAmount,
            validAfter, 
            validBefore, 
            nonce, 
            v, 
            r, 
            s
        );

        IERC20(si.token).approve(address(LOCKUP), si.totalAmount);

        Lockup.CreateWithDurations memory streamParams = Lockup.CreateWithDurations({
            sender: si.sender,
            recipient: si.recipient,
            totalAmount: uint128(si.totalAmount),
            cancelable: si.cancelable,
            transferable: si.transferable,
            token: IERC20(address(si.token)),
            shape: "linear",
            broker: Broker(address(0), ud60x18(0))
        });

        LockupLinear.UnlockAmounts memory unlockAmounts = LockupLinear.UnlockAmounts({ start: 0, cliff: 0 });

        return LOCKUP.createWithDurationsLL(streamParams, unlockAmounts, durations);
    }
}