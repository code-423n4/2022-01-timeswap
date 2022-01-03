// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

import {ILiquidity} from './interfaces/ILiquidity.sol';
import {IConvenience} from './interfaces/IConvenience.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
import {ERC20Permit} from './base/ERC20Permit.sol';
import {SafeMetadata} from './libraries/SafeMetadata.sol';
import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';

contract Liquidity is ILiquidity, ERC20Permit {
    using SafeMetadata for IERC20;
    using Strings for uint256;

    IConvenience public immutable override convenience;
    IPair public immutable override pair;
    uint256 public immutable override maturity;

    uint8 public constant override decimals = 18;

    function name() external view override returns (string memory) {
        string memory assetName = pair.asset().safeName();
        string memory collateralName = pair.collateral().safeName();
        return
            string(
                abi.encodePacked('Timeswap Liquidity - ', assetName, ' - ', collateralName, ' - ', maturity.toString())
            );
    }

    function symbol() external view override returns (string memory) {
        string memory assetSymbol = pair.asset().safeSymbol();
        string memory collateralSymbol = pair.collateral().safeSymbol();
        return string(abi.encodePacked('TS-LIQ-', assetSymbol, '-', collateralSymbol, '-', maturity.toString()));
    }

    function totalSupply() external view override returns (uint256) {
        return pair.liquidityOf(maturity, address(this));
    }

    constructor(
        IConvenience _convenience,
        IPair _pair,
        uint256 _maturity
    ) ERC20Permit('Timeswap Liquidity') {
        convenience = _convenience;
        pair = _pair;
        maturity = _maturity;
    }

    modifier onlyConvenience() {
        require(msg.sender == address(convenience), 'E403');
        _;
    }

    function mint(address to, uint256 amount) external override onlyConvenience {
        _mint(to, amount);
    }

    function burn(
        address from,
        address assetTo,
        address collateralTo,
        uint256 amount
    ) external override onlyConvenience returns (IPair.Tokens memory tokensOut) {
        _burn(from, amount);

        tokensOut = pair.burn(maturity, assetTo, collateralTo, amount);
    }
}
