// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address public sigA;
    address public sigB;
    address public payer;

    constructor(address _payer){
        payer = _payer;
    }

    enum Signed {FULLYSIGNED, PARTIALYSIGNED, NOTSIGNED}
    
    error AlreadySigned(address signer);
    error NotAuthorized(address signer);
    error NOTSIGNED();

    mapping (address => bool) public hasSigned;
    mapping (address => bool) public signedWallet;


    function registerSignature (address _signA, address _signB) public {
        if(sigA != address(0)){
            revert AlreadySigned(_signA);
        }

        if(sigB != address(0)){
            revert AlreadySigned(_signB);
        }
        sigA = _signA;
        sigB = _signB;

    }

    function signWallet (address wallet) public {
    if (msg.sender != sigA && msg.sender != sigB) {
        revert NotAuthorized(msg.sender);
    }

    if (hasSigned[msg.sender]) {
        revert AlreadySigned(msg.sender);
    }

    hasSigned[msg.sender] = true;

    if (hasSigned[sigA] && hasSigned[sigB]) {
        signedWallet[wallet] = true;
    }
    }

    function transferFund (address wallet) public payable {
        require(signedWallet[wallet], "wallet needs to be signed");
        
        (bool success, ) = payable(wallet).call{value: msg.value}("");
        require(success, "Transfer failed");
    }

}