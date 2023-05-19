// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/NightHam.sol";

contract TestContract is Test {
    NightHam puzzle;
    address me = 0xB95777719Ae59Ea47A99e744AfA59CdcF1c410a1;
    address curtaAddress = 0x0000000006bC8D9e5e9d436217B88De704a9F307;
    address puzzleAddress = 0x5130522c3579Dcdf1A4EaE2eBf3592AA4a3226f0;

    function setUp() public {
        puzzle = new NightHam();
    }

    function testSolve() public {
        uint256 myPuzzle = puzzle.generate(me);
        console2.logBytes32(bytes32(myPuzzle));
        puzzle.verify(myPuzzle, 0x4);
    }
}
