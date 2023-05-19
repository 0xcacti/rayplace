// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import { IPuzzle } from "./interfaces/IPuzzle.sol";

contract NightHam is IPuzzle {
    uint256 constant alexander = 68; // 17 * 4
    uint256 constant lewis = 60; // 15 * 4
    uint256 constant antony = 40; // 10 * 4
    uint256 constant rowan = 36; // 6 * 4
    /// @inheritdoc IPuzzle

    function name() external pure returns (string memory) {
        return "Night Ham";
    }

    /// @inheritdoc IPuzzle
    function generate(address _seed) external pure returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(_seed)));
        return 2 << (seed % 64) * 4;
    }

    function verify(uint256 _start, uint256 _solution) external pure returns (bool) {

        uint256 position = _start;
        console2.logBytes32(bytes32(_start));

        for (; _solution != 0; _solution >>= 4) {
            uint256 move = _solution & 0xf;

            assembly {
                switch move
                case 0 {
                    position := shr(alexander, position)
                    _start := or(_start, position)
                }
                case 1 {
                    position := shr(lewis, position)
                    _start := or(_start, position)
                }
                case 2 {
                    position := shr(antony, position)
                    _start := or(_start, position)
                }
                case 3 {
                    position := shr(rowan, position)
                    _start := or(_start, position)
                }
                case 4 {
                    position := shl(rowan, position)
                    _start := or(_start, position)
                }
                case 5 {
                    position := shl(antony, position)
                    _start := or(_start, position)
                }
                case 6 {
                    position := shl(lewis, position)
                    _start := or(_start, position)
                }
                case 7 {
                    position := shl(alexander, position)
                    _start := or(_start, position)
                }
            }

            if (position ^ _start != 0) return false;
        }
        return position
            == 15_438_945_231_642_159_389_809_464_667_825_054_380_435_997_955_418_741_871_927_677_867_721_750_618_658;
    }
}

    /// @inheritdoc IPuzzle
    function verifyTemp(uint256 _start, uint256 _solution) external view returns (bool) {
        // set temporary custom start
        uint256 _start = 0x0000000000000000000000000000000000000000000000000000000000000002;

        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  2

        // alexander (VALID)
        // 0  0  0  0  0  0  2  0
        // 0  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  2

        // lewis (INVALID)
        // 2  0  0  0  0  0  0  0
        // 0  0  0  0  0  0  0  2

        // antony (VALID)
        // 0  0  0  0  0  2  0  0
        // 0  0  0  0  0  0  0  2

        // rowan (INVALID)
        // 0  0  0  0  0  0  2  0
        // 0  0  0  0  0  0  0  2
        uint256 position = _start;
        console2.logBytes32(bytes32(_start));

        for (; _solution != 0; _solution >>= 4) {
            uint256 move = _solution & 0xf;

            assembly {
                switch move
                case 0 {
                    position := shr(alexander, position)
                    _start := or(_start, position)
                }
                case 1 {
                    position := shr(lewis, position)
                    _start := or(_start, position)
                }
                case 2 {
                    position := shr(antony, position)
                    _start := or(_start, position)
                }
                case 3 {
                    position := shr(rowan, position)
                    _start := or(_start, position)
                }
                case 4 {
                    position := shl(rowan, position)
                    _start := or(_start, position)
                }
                case 5 {
                    position := shl(antony, position)
                    _start := or(_start, position)
                }
                case 6 {
                    position := shl(lewis, position)
                    _start := or(_start, position)
                }
                case 7 {
                    position := shl(alexander, position)
                    _start := or(_start, position)
                }
            }

            if (position ^ _start != 0) return false;
        }
        return position
            == 15_438_945_231_642_159_389_809_464_667_825_054_380_435_997_955_418_741_871_927_677_867_721_750_618_658;
    }
}

// console2.logBytes32(bytes32(_start));
// console2.log("start");

// console2.logBytes32(bytes32(_start | _start >> 17 * 4));
// console2.logBytes32(bytes32(_start | _start >> 15 * 4));
// console2.logBytes32(bytes32(_start | _start >> 10 * 4));
// console2.logBytes32(bytes32(_start | _start >> 6 * 4));
// console2.logBytes32(bytes32(_start | _start << 6 * 4));
// console2.logBytes32(bytes32(_start | _start << 10 * 4));
// console2.logBytes32(bytes32(_start | _start << 15 * 4));
// console2.logBytes32(bytes32(_start | _start << 17 * 4));

// 0x0000000000x0x0000x000x00000200000x000x0000x0x0000000000000000000
// good
// 0x0000000000000000000000000002000000000000000020000000000000000000
// 0x0000000000000000000000000002000000000000000020000000000000000000
// good
// 0x0000000000000000000000000002000000000000002000000000000000000000
// 0x0000000000000000000000000002000000000000002000000000000000000000
// good
// 0x0000000000000000000000000002000000000200000000000000000000000000
// 0x0000000000000000000000000002000000000200000000000000000000000000
// good
// 0x0000000000000000000000000002000002000000000000000000000000000000
// 0x0000000000000000000000000002000002000000000000000000000000000000
// good
// 0x0000000000000000000002000002000000000000000000000000000000000000
// 0x0000000000000000000002000002000000000000000000000000000000000000
// good
// 0x0000000000000000020000000002000000000000000000000000000000000000
// 0x0000000000000000020000000002000000000000000000000000000000000000
// good
// 0x0000000000002000000000000002000000000000000000000000000000000000
// 0x0000000000002000000000000002000000000000000000000000000000000000
// good
// 0x0000000000200000000000000002000000000000000000000000000000000000
// 0x0000000000200000000000000002000000000000000000000000000000000000
//
// uint256 _start = 0x0000000000000000000000000002000000000000000000000000000000000000;

// 0  0  0  0  0  0  0  0
// 0  0  x  0  x  0  0  0
// 0  x  0  0  0  x  0  0
// 0  0  0  2  0  0  0  0
// 0  x  0  0  0  x  0  0
// 0  0  x  0  x  0  0  0
// 0  0  0  0  0  0  0  0
// 0  0  0  0  0  0  0  0
