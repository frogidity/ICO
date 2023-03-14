// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevsToken is ERC20, Ownable {

    uint public constant tokenPrice = 0.001 ether;
    uint public constant tokenPerNFT = 10 * 10**18;
    uint public constant maxTotalSupply = 10000 * 10**18;
    ICryptoDevs CryptoDevsNFT;
    mapping(uint => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(uint amount) public payable {
        uint _requiredamount = tokenPrice * amount;
        require(msg.value >= _requiredamount, "Incorrect ether amount");
        uint amountWithDecimals = amount * 10**18;
        require((totalSupply() + amountWithDecimals) <= maxTotalSupply, "Exceeds the max total supply available");
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {

        address sender = msg.sender;
        uint balance = CryptoDevsNFT.balanceOf(sender);
        require(balance > 0, "You don't own any Crypto Dev NFT");
        uint amount = 0;
        for (uint i =0; i < balance; i++) {
            uint tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed all tokens");
        _mint(msg.sender, amount * tokenPerNFT);
    }

    function withdraw() public {
        uint amount = address(this).balance;

        require(amount > 0, "Nothing to withdraw, contract balance empty");
        address _owner = owner();
        (bool sent,) = _owner.call{value: amount}("");
        require(sent, "failed to send ether");
    }
    

    receive() external payable {}

    fallback() external payable {}

}