// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library BondMath {

    //caculate the value of bonds hold
    function calculateFaceValue(uint256 bondUnit, uint256 faceValue)
        internal
        pure
        returns (uint256)
    {
        return (bondUnit * faceValue) / (10**18);
    }

    //calculate the bonds amount 
    function calculateBondAmountWithFixPrice(
        uint256 faceAmount,
        uint256 issuePrice
    ) internal pure returns (uint256) {
        return (faceAmount * (10**18)) / issuePrice;
    }

    function calculateUnderlyingAsset(
        uint256 bondBalance,
        uint256 bondSupply,
        uint256 underlyingAmount
    ) internal pure returns (uint256) {
        return (bondBalance * underlyingAmount) / bondSupply;
    }

    function calculateRemainderUnderlyingAsset(
        uint256 totalBondSupply,
        uint256 currentBondSupply,
        uint256 underlyingAmount
    ) internal pure returns (uint256) {
        return (totalBondSupply - currentBondSupply) * underlyingAmount / totalBondSupply;
    }

}