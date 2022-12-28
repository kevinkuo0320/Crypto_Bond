// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICryptoBond {

    event BondCreated(
        string bondName,
        string bondSymbol,
        address underlyingAsset,
        uint256 collateralAmount,
        address faceAsset,
        uint256 faceValue,
        uint256 totalSupply
    );

    event BondActivated(uint64 onSale, uint64 active, uint64 maturity);
    event SoldAmountClaimed(address issuer, uint256 amount);
    event Purchased(address user, uint256 faceAmount, uint256 bondAmount);
    event IssuePriceInitialized(uint256 issuePrice);

    /// When the bond is pending, Issuer active the bond by transferring the underlying asset and call active function
    /// @param _startSale unix timestamp sale date
    /// @param _active unix timestamp active date
    /// @param _maturity unix timestamp maturity date
    /**
     * Requirements:
     *
     * - Caller must be the issuer
     * - Only when the underlying asset is not deposited
     * - _startSale < _active < _maturity
     */

    function active(
        uint64 _startSale,
        uint64 _active,
        uint64 _maturity
    ) external;

    /// When the bond is matured, Issuer claim underlying asset
    /// check only issuer, only the bond is matured
    /**
     * Requirements:
     *
     * - Caller must be the issuer
     * - Only Matured
     * - Only issuer pay back the face value
     */
    function claimUnderlyingAsset() external;


    /// When the bond is active, issuer can claim the sold amount
    /// Requirements:
    /// - Bond is activated
    function claimSoldAmount(uint256 amount) external;

    /// When the bond is not on sale, issuer can claim remainder underlying asset
    /// Requirements:
    /// - Bond is not on sale
    /// - Only issuer
    function claimRemainderUnderlyingAsset() external;

    /// When the bond is matured, investor must claim back the face value buy transfer the bond unit and returns the face amount
    /// Get back the bond token, and transfer face asset to caller
    /// Requirements
    /// - The bond must be matured
    function claimFaceValue() external;

    /// When the bond is on sale, users must be able to purchase the bond
    /// Users pay by the face assets and get back the bond token base on Bond strategy
    /**
    * Requirements:
     * - The bond must be on sale
     */
    function purchase(uint256 amount) external;


    function isPurchasable(address caller) external view returns (bool);
}