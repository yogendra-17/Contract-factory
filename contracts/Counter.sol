// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Counter is Initializable {
    uint256 public counter;

    function initialize(uint256 _counter) public {
        counter = _counter;
    }

    function increment(uint256 _number) public {
        counter = counter + _number;
    }

    function decrement(uint256 _number) public {
        counter = counter - _number;
    }
}