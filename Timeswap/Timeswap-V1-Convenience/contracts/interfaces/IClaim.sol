// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

import {IERC20Permit} from './IERC20Permit.sol';
import {IConvenience} from './IConvenience.sol';
import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';

/// @author Ricsson W. Ngo
interface IClaim is IERC20Permit {
    // VIEW

    function convenience() external returns (IConvenience);

    function pair() external returns (IPair);

    function maturity() external returns (uint256);

    // UPDATE

    function mint(address to, uint128 amount) external;

    function burn(
        address from,
        address to,
        uint128 amount
    ) external returns (uint128 tokenOut);
}
