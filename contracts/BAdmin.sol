pragma solidity ^0.5.16;

import "./Ownable/Ownable.sol";

interface SetSeizePausedLike {
    function _setSeizePaused(bool state) external returns (bool);
}

// initially deployer owns it, and then it moves it to the DAO
contract BAdmin is Ownable {
    mapping(address => bool) public seizePausedAuth;

    event SeizePausedAuthSet(address a, bool set);
    event SeizePausedSet(address indexed sender, SetSeizePausedLike comptroller, bool state);

    constructor() public {
        transferOwnership(msg.sender);
    }

    function op(address payable target, bytes calldata data, uint value) onlyOwner external payable {
        target.call.value(value)(data);
    }
    function() payable external {}

    function setSeizePausedAuth(address a, bool set) public onlyOwner {
        seizePausedAuth[a] = set;
        emit SeizePausedAuthSet(a, set);
    }

    function setSeizePaused(SetSeizePausedLike comptroller, bool state) public {
        require(seizePausedAuth[msg.sender], "!auth");
        comptroller._setSeizePaused(state);

        emit SeizePausedSet(msg.sender, comptroller, state);
    }
}