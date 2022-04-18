pragma solidity ^0.5.16;

import "./Ownable/Ownable.sol";

interface ComptrollerLike {
    function _setSeizePaused(bool state) external returns (bool);
    function _acceptAdmin() external returns (uint);
    function _setPendingAdmin(address newPendingAdmin) external returns (uint);
}

interface ERC20Like {
    function balanceOf(address a) external returns(uint);
    function transfer(address to, uint amount) external returns(bool);
}

// initially deployer owns it, and then it moves it to the DAO
contract BAdmin is Ownable {
    mapping(address => bool) public collectFeesAuth;
    mapping(address => bool) public seizePausedAuth;
    ComptrollerLike public comptroller; 

    event CollectFeesAuthSet(address a, bool set);
    event SeizePausedAuthSet(address a, bool set);
    event SeizePausedSet(address indexed sender, bool state);

    constructor(ComptrollerLike _comptroller) public {
        comptroller = _comptroller;
        transferOwnership(msg.sender);
    }

    function op(address payable target, bytes calldata data, uint value) onlyOwner external payable {
        target.call.value(value)(data);
    }
    function() payable external {}

    function acceptCompAdmin() public onlyOwner {
        comptroller._acceptAdmin();
    }

    function setCompAdmin(address newPendingAdmin) public onlyOwner {
        comptroller._setPendingAdmin(newPendingAdmin);
    }

    function setSeizePausedAuth(address a, bool set) public onlyOwner {
        seizePausedAuth[a] = set;
        emit SeizePausedAuthSet(a, set);
    }

    function _setSeizePaused(bool state) public returns(bool) {
        require(seizePausedAuth[msg.sender], "!auth");
        comptroller._setSeizePaused(state);

        emit SeizePausedSet(msg.sender, state);

        return state;    
    }

    function setCollectFeeAuth(address a, bool set) public onlyOwner {
        collectFeesAuth[a] = set;
        emit CollectFeesAuthSet(a, set);
    }

    function collectFees(ERC20Like token) public {
        require(collectFeesAuth[msg.sender], "!auth");

        if(token == ERC20Like(0x0)) msg.sender.transfer(address(this).balance);
        else token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}