// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address public sigA;
    address public sigB;
    address public walletAddress;

    enum Signed {FULLYSIGNED, PARTIALYSIGNED, NOTSIGNED}
    
    error AlreadySigned(address signer);
    error NotAuthorized(address signer);

    mapping (address => bool) public hasSigned;


    function signWallet(address _signA, address _signB) public {

    }

}