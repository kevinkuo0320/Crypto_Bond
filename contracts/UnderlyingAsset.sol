// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./bondMath.sol";

abstract contract UnderlyingAsset {
    using SafeERC20 for IERC20;

    IERC20 public _underlyingAsset;
    uint256 public _underlyingAmount;
    bool _remainderUnderlyingClaimed;
    address issuer; 

    constructor(address underlyingAsset_, uint256 underlyingAmount_, address issuer_) {
        _underlyingAsset = IERC20(underlyingAsset_);
        _underlyingAmount = underlyingAmount_;
        issuer = issuer_; 
    }

    function claimUnderlyingAsset() public virtual {
        _underlyingAsset.safeTransfer(
            _issuer(),
            _underlyingAmount
        );
    }


    function _transferUnderlyingAsset() internal virtual {
        if (address(_underlyingAsset) != address(0)) {
            _underlyingAsset.safeTransferFrom(
                msg.sender,
                address(this),
                _underlyingAmount
            );
            //require(_underlyingAsset.balanceOf(address(this)) >= _underlyingAmount, "need to cover deflection fees");
        }
    }


    function _transferRemainderUnderlyingAsset(
        uint256 totalBondSupply,
        uint256 currentBondSupply
    ) internal {
        require(_remainderUnderlyingClaimed == false, "already claimed");
        uint256 remainderUnderlyingAsset = BondMath
            .calculateRemainderUnderlyingAsset(
                totalBondSupply,
                currentBondSupply,
                _underlyingAmount
            );
        _remainderUnderlyingClaimed = true;
        _underlyingAsset.safeTransfer(msg.sender, remainderUnderlyingAsset);
    }

    function _issuer() internal view virtual returns (address) {
        return issuer; 
    }

}