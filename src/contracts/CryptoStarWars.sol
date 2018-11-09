pragma solidity ^0.4.24;

import "./ERC721.sol";
import "./SafeMath.sol";
import "./Factory.sol";

contract CryptoStarWars is ERC721, Factory {

  using SafeMath for uint256;

  mapping (uint => address) approvals;
  
  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == tokenToOwner[_zombieId]);
    _;
  }

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return tokenToOwner[_tokenId];
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    approvals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }
  
  function takeOwnership(uint256 _tokenId) public {
    require(approvals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }    

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerCount[_to] = ownerCount[_to].add(1);
    ownerCount[msg.sender] = ownerCount[msg.sender].sub(1);
    tokenToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }
}