// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./FaceAsset.sol"; 
import "./UnderlyingAsset.sol"; 
import "./ICryptoBonds.sol"; 


contract CryptoBonds is ICryptoBond, FaceAsset, UnderlyingAsset, ERC20, ReentrancyGuard {

    string public bondName; 
    string public bondSymbol; 
    address underlyingAsset; 
    uint256 collateralAmount; 
    address faceAsset; 
    uint256 public faceValue; 
    uint256 public immutable totalBondsSupply; 
    uint256 public bondSupply; 
    address public bondIssuer; 

    uint64 public startTime; 
    uint64 public activeSaleTime; 
    uint64 public maturityTime; 

    bool canPurchase; 

    /** 
    * bondName & bondSymbol: name and symbol of the bond
    * underlyAsset: issuer need to lock their ETH/tokens
    * faceAsset: tokens users use to buy the bonds
    * faceValue: price per bonds 
    * totalSupply: total number of bonds issued 
    */ 

    constructor(
        string memory bondName_,
        string memory bondSymbol_,
        address underlyingAsset_,
        uint256 collateralAmount_,
        address faceAsset_,
        uint256 faceValue_,
        uint256 totalBondsSupply_
    )   FaceAsset(faceAsset_, faceValue_)
        UnderlyingAsset(underlyingAsset_, collateralAmount_, msg.sender)
        ERC20(bondName_, bondSymbol_)
    {
        bondName = bondName_; 
        bondSymbol = bondSymbol_; 
        underlyingAsset = underlyingAsset_; 
        collateralAmount = collateralAmount_; 
        faceAsset = faceAsset_; 
        faceValue = faceValue_; 
        totalBondsSupply = totalBondsSupply_; 
        issuer = msg.sender; 
    }

    modifier onlyIssuer() {
        require(msg.sender == issuer, "only issuer");
        _;
    }

    modifier onlyActive() {
        require(activeSaleTime < _now() && _now() < maturityTime, "not actived time"); 
        _; 
    }

    modifier onlyMatured() {
        require(maturityTime < _now(), "not maturity time"); 
        _; 
    }

    modifier onlyOnSale() {
        require(startTime < _now() && _now() < maturityTime, "not sale time"); 
        _; 
    }

    modifier purchasable() {
        require(canPurchase, "cannot purchase"); 
        _; 
    }

    function pausePurchaseBonds() external onlyIssuer onlyActive {
        canPurchase = false; 
    }

    function resumePurchaseBonds() external onlyIssuer onlyActive {
        canPurchase = true; 
    }

    function _now() internal view returns(uint256) {
        return block.timestamp; 
    }

    /**
    * calculate the value of bonds an user holds
    */ 
    function faceAmount(address account) external view returns(uint256) {
        return FaceAsset._calculateFaceValueOut(balanceOf(account));
    }

    /**
     * active bonds for purchasing
     */
    function active(
        uint64 _startTime,
        uint64 _activeSaleTime,
        uint64 _maturityTime
    ) public onlyIssuer nonReentrant {
        startTime = _startTime; 
        activeSaleTime = _activeSaleTime; 
        maturityTime = _maturityTime; 
        canPurchase = true; 
        emit BondActivated(_startTime, _activeSaleTime, _maturityTime);
    }

    /**
     * when the bonds is matured, issuer can claim back the underlying assets
     */
    function claimUnderlyingAsset()
        public
        override(ICryptoBond, UnderlyingAsset)
        onlyIssuer
        onlyMatured
        nonReentrant
    {
        UnderlyingAsset.claimUnderlyingAsset();
    }

    // when the bonds is activated, issuer can claim the sold amount
    function claimSoldAmount(uint256 amount) external virtual onlyIssuer onlyActive nonReentrant {
        FaceAsset._transferOut(msg.sender, amount);
        emit SoldAmountClaimed(msg.sender, amount);
    }

    /**
     * when the bonds is matured, users can claim back their face value
     */
    function claimFaceValue() external onlyMatured nonReentrant {
        uint256 _bondBalance = balanceOf(msg.sender);
        require(_bondBalance != 0, "invalid bond balance");
        _burn(msg.sender, _bondBalance);
        FaceAsset._transferFaceValueOut(_bondBalance);
    }

    /**
     * issuer can claim back the remaining underlying asset if bonds not sold out
     */
    function claimRemainderUnderlyingAsset()
        external
        onlyActive
        onlyIssuer
    {
        UnderlyingAsset._transferRemainderUnderlyingAsset(
            bondSupply,
            totalBondsSupply
        );
    }

    /**
     * user pay by face asset to buy the bonds, return back the bonds token
     */
    function purchase(uint256 amount) external onlyOnSale purchasable nonReentrant {
        require(amount != 0, "invalid amount");
        (uint256 _bondAmount, uint256 _faceAmount) = getBondAmount(amount);
        require(_faceAmount != 0 && _bondAmount != 0, "out of bond");
        FaceAsset._transferIn(_faceAmount);
        _mint(msg.sender, _bondAmount);
        emit Purchased(msg.sender, _faceAmount, _bondAmount);
    }

    function isPurchasable(address caller) public view virtual returns (bool){}


    function _transferUnderlyingAsset()
        internal
        override(UnderlyingAsset)
    {
        UnderlyingAsset._transferUnderlyingAsset();
    }

     function _mint(address account, uint256 amount) internal override(ERC20) {
        super._mint(account, amount);
        bondSupply += amount; 
        require(totalBondsSupply <= bondSupply , "over supply");
    }

    function getBondAmount(uint256 amount)
        public
        view
        virtual
    returns (uint256 bondAmount, uint256 faceAmount) {
            bondAmount = totalBondsSupply - bondSupply; 
            uint256 userBalance = FaceAsset._getUserBalance(); 
            faceAmount = userBalance / faceValue - amount; 
            return (bondAmount, faceAmount); 
    }


}