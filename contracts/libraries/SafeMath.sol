// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.6.12;

/// @notice A library for performing under/overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math).
library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "SafeMath:Add-Over");
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "SafeMath:Sub-Over");
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "SafeMath:Mul-Over");
    }
}
