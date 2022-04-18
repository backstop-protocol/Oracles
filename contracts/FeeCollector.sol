pragma solidity ^0.5.16;


interface FERC20Like {
    function _withdrawAdminFees(uint withdrawAmount) external returns (uint);
    function totalAdminFees() external view returns(uint);
    function mint() external payable;
    function balanceOf(address a) external returns(uint);
    function transfer(address to, uint amount) external returns(bool);
}

interface BAdminLike {
    function collectFees(address token) external;
}

interface BAMMLike {
    function cBorrow() external returns(FERC20Like);
}

contract ETHFeeCollector {
    address public bamm;
    address public daoFeePool;
    FERC20Like public fToken;
    uint public daoFees;

    event CollectFeeEvent(address amount);

    constructor(address _bamm, address _daoFeePool, uint _daoFees) public {
        bamm = _bamm;
        daoFeePool = _daoFeePool;
        daoFees = _daoFees;
        fToken = BAMMLike(bamm).cBorrow();
    }

    // callable by anyone
    function collectFees(address admin) public {
        fToken._withdrawAdminFees(fToken.totalAdminFees());

        BAdminLike(admin).collectFees(address(0x0));
        fToken.mint.value(address(this).balance)();

        uint fBalance = fToken.balanceOf(address(this));
        uint fee = fBalance * daoFees / 10000;

        if(fee > 0) fToken.transfer(daoFeePool, fee);
        if(fBalance > fee) fToken.transfer(bamm, fBalance - fee);
    }

    function() payable external {}
}
