pragma solidity ^0.5.16;

import "./Interfaces/PriceOracle.sol";

contract FakeAmpOracle is PriceOracle {
    PriceOracle public realOracle;
    uint public ampFactor = 1000;
    address public admin;

    constructor(PriceOracle _realOracle) public {
        realOracle = _realOracle;
        admin = msg.sender;
    }

    function setAmpFactor(uint _factor) public {
        require(admin == msg.sender, "!admin");
        ampFactor = _factor;
    }

    function getUnderlyingPrice(address cToken) public view returns(uint) {
        // this is only for tests. so we don't check for overflows.
        return ampFactor * realOracle.getUnderlyingPrice(cToken);
    }
}