// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address public payer;
    address[] public signers;
    address[] public walletOwners;
    uint256 public immutable requiredApprovals;


    constructor(address _payer, uint256 _requiredApprovals){
        payer = _payer;
        requiredApprovals = _requiredApprovals;
    }

    enum Signed {FULLYSIGNED, PARTIALYSIGNED, NOTSIGNED}
    
    error AlreadySigned(address signer);
    error NotAuthorized(address signer);
    error NOTSIGNED();

    mapping(address => mapping(address => bool)) public hasApproved; 
    mapping(address => uint256) public approvalCount;  
    mapping (address => bool) public signedWallet;
    mapping(address => bool) public isSigner;


    function registerSignature (address _sign) public {
       if (isSigner[_sign]) {
        revert AlreadySigned(_sign);
        }

        isSigner[_sign] = true;
        signers.push(_sign);

    }
  

    function signWallet(address wallet) public {
        if (!isSigner[msg.sender]) {
            revert NotAuthorized(msg.sender);
        }

        if (hasApproved[wallet][msg.sender]) {
            revert AlreadySigned(msg.sender);
        }

        hasApproved[wallet][msg.sender] = true;
        approvalCount[wallet] += 1;

        if (approvalCount[wallet] >= requiredApprovals) {
            signedWallet[wallet] = true;
        }
    }


    function transferFund (address wallet) public payable {
        require(signedWallet[wallet], "wallet needs to be signed");
        
        (bool success, ) = payable(wallet).call{value: msg.value}("");
        require(success, "Transfer failed");
    }

}