// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./bondMath.sol"; 

abstract contract FaceAsset {
    using SafeERC20 for IERC20;

    event FaceValueClaimed(address user, uint256 amount);
    event FaceValueDeposited(uint256 amount);
    event FaceValueRepaid(
        uint256 amount,
        uint256 bondAmount,
        uint256 faceValue
    );

    IERC20 public _faceAsset;
    uint256 private _faceValue;

    constructor(address faceAsset_, uint256 faceValue_) {
        _faceAsset = IERC20(faceAsset_);
        _faceValue = faceValue_;
    }

    //transfer face asset from user to this contract
    function _transferIn(uint256 amount) internal virtual {
        _faceAsset.safeTransferFrom(msg.sender, address(this), amount);
    }

    //transfer out face asset back to user
    function _transferOut(address recipient, uint256 amount) internal virtual {
        _faceAsset.safeTransfer(recipient, amount);
    }


    function _calculateFaceValueOut(uint256 bondAmount) internal virtual view returns(uint256){
        return BondMath.calculateFaceValue(
            bondAmount,
            _faceValue
        );
    }

    /// @dev Calculate the face value and transfer in
    /// @param bondAmount The bond amount
    function _transferFaceValueOut(uint256 bondAmount) internal virtual {
        uint256 calculatedFaceValue = BondMath.calculateFaceValue(
            bondAmount,
            _faceValue
        );
        _transferOut(msg.sender, calculatedFaceValue);
        emit FaceValueClaimed(msg.sender, calculatedFaceValue);
    }

    function _getUserBalance() internal view returns(uint256) {
        return _faceAsset.balanceOf(msg.sender); 
    }
}