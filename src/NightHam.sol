// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import { IPuzzle } from "./interfaces/IPuzzle.sol";

contract NightHam is IPuzzle {
    /// @inheritdoc IPuzzle
    function name() external pure returns (string memory) {
        return "Night Ham";
    }

    /// @inheritdoc IPuzzle
    function generate(address _seed) external pure returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(_seed)));
        return 7 << (seed % 64) * 4;
    }

    /// @inheritdoc IPuzzle
    function verify(uint256 _start, uint256 _solution) external pure returns (bool) {
        return false;
    }
}
