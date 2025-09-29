// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.22;

interface IERC20 {
    function approve(address spender, uint256 value) external returns (bool);
}