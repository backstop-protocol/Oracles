pragma solidity ^0.5.16;

import "./SafeMath/Exponential.sol";
import "./Interfaces/UniswapV2Interface.sol";
import "./Interfaces/PriceOracle.sol";

contract FakeCER20 {
    address public underlying;
    bool public constant isCEther = false;
    constructor(address _underlying) public {
        underlying = _underlying;
    }

    function() external {
        revert(string(msg.data));
    }
}

interface IPJar {
    function totalSupply() external view returns(uint256);
    function token() external view returns(address);
    function balance() external view returns(uint256);
}

contract PickleUniLPOracle is Exponential, PriceOracle {
    mapping(address => address) public fakeCToken;
    PriceOracle public defaultOracle;

    constructor(address _defaultOracle) public {
        defaultOracle = PriceOracle(_defaultOracle);
    }

    // callable by anyone
    function setFakeCToken(address underlying) public {
        require(fakeCToken[underlying] == address(0), "setFakeCToken: already init");
        fakeCToken[underlying] = address(new FakeCER20(underlying));
    }

    function getTokenPrice(address token) internal view returns(uint256) {
        return defaultOracle.getUnderlyingPrice(fakeCToken[token]);
    }

    function getLPFairPrice(address pair) public view returns (uint256) {
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();
        (uint256 r0, uint256 r1, ) = IUniswapV2Pair(pair).getReserves();
        uint256 sqrtR = sqrt(mul_(r0, r1));
        uint256 p0 = getTokenPrice(token0);
        uint256 p1 = getTokenPrice(token1);
        uint256 sqrtP = sqrt(mul_(p0, p1));
        return div_(mul_(2, mul_(sqrtR, sqrtP)), totalSupply);
    }

    function getUnderlyingPrice(address cToken) external view returns (uint256) {
        IPJar pJar = IPJar(FakeCER20(cToken).underlying());
        uint256 lpTokenFairPrice = getLPFairPrice(pJar.token());
        
        return div_(mul_(lpTokenFairPrice, pJar.balance()), pJar.totalSupply());
    }
}