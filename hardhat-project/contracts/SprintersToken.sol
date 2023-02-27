// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ISprinters.sol";

contract SprintersToken is ERC20, Ownable{
    uint256 public constant tokenPrice = 0.0001 ether;
    uint256 public constant tokensPerNFT = 10 * 10**18;
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    ISprinters SprintersNFT;
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor (address _sprintersContract) ERC20 ("Sprinters Token", "SRT"){
        SprintersNFT = ISprinters(_sprintersContract);
    }

    function mint(uint256 amount) public payable{
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value > _requiredAmount, "Ether sent is incorrect");
        uint256 amountWithDecimals = amount * 10**18;
        require(totalSupply() + amountWithDecimals <= maxTotalSupply, "Exceeds the max totoal supply available");

        _mint(msg.sender, amountWithDecimals);
    }
    
    function claim() public {
        address sender = msg.sender;
        uint256 balance = SprintersNFT.balanceOf(sender);
        require(balance>0, "You don't own any NFT");
        uint256 amount = 0;
        for(uint256 i=0;i<balance; ++i)
        {
            uint256 tokenId = SprintersNFT.tokenOfOwnerByIndex(sender,i);
            if(!tokenIdsClaimed[tokenId]){
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount>0, "You have already claimed all the tokens");

        _mint(msg.sender, amount*tokensPerNFT);
    }

    function withdraw() public onlyOwner{
        uint256 amount = address(this).balance;
        require(amount>0, "Nothing to withdraw");
        address _owner = owner();
        (bool sent, ) = _owner.call{value:amount}("");
        require(sent, "Failed to send ether");
    }   

    receive() external payable {}

    fallback() external payable {} 
}