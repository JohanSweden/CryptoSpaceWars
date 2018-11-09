pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Factory is Ownable {

  using SafeMath for uint256;

  event NewToken(uint tokenId, bytes16 name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Token {
    bytes16 name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Token[] public tokens;

  mapping (uint => address) public tokenToOwner;
  mapping (address => uint) ownerCount;

  function _createToken(bytes16 _name, uint _dna) internal {
    uint id = tokens.push(Token(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    tokenToOwner[id] = msg.sender;
    ownerCount[msg.sender] = ownerCount[msg.sender].add(1);
    emit NewToken(id, _name, _dna);
  }

  function _generateRandomDna(bytes16 _str) private view returns (uint) {
    uint rand = uint(keccak256(_str));
    return rand % dnaModulus;
  }

  function createRandomToken(bytes16 _name) public {
    require(ownerCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createToken(_name, randDna);
  }
}
