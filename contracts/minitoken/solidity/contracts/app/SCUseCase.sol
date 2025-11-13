// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "@hyperledger-labs/yui-ibc-solidity/contracts/apps/commons/IBCAppBase.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IBCHandler.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";
import "../lib/Packet.sol";
import "./interfaces/IAnchoring.sol";

contract SCUseCase{

    address private owner;
    IAnchoring private anchoringSC;
    mapping (address => bytes32) private userHash;
    mapping (bytes32 => address) private hashUser;
    
    string sourcePort;
    string sourceChannel;
    uint64 timeoutHeight;


    constructor(address _anchoring) {
        owner = msg.sender;
        anchoringSC = IAnchoring(_anchoring);
    }

    event SetUserHash(address indexed holder, bytes32 hash);
    event AnchorInfo(address, bytes32, string, string ,uint64);

    modifier onlyOwner() {
        require(msg.sender == owner, "SCUseCase: caller is not the owner");
        _;
    }

    function anchoringSCAddress() public view returns (address) {
        return address(anchoringSC);
    }

    function setUserHash(address _holder, bytes32 _hash) external {
        userHash[_holder] = _hash;
        hashUser[_hash] = _holder;
        emit SetUserHash(_holder, _hash);
    }

    function getHash(address _holder) external view returns(bytes32){
        return userHash[_holder];
    }

    function getUser(bytes32 _hash) external view returns(address){
        return hashUser[_hash];
    }

    function setCommParams(string memory _sourcePort, 
                        string memory _sourceChannel,
                        uint64 _timeoutHeight) external{
        sourcePort = _sourcePort;
        sourceChannel = _sourceChannel;
        timeoutHeight = _timeoutHeight;

    }

    function anchorPair(address _holder) external returns(bool){
        require(userHash[_holder]!="0x0", "Holder and hash not set");
        bytes32 hash = userHash[_holder];
        bytes memory dataToAnchor = bytes(abi.encode(_holder, hash));

        anchoringSC.sendTransfer(dataToAnchor, msg.sender, sourcePort, sourceChannel, timeoutHeight);
        emit AnchorInfo(_holder, hash, sourcePort, sourceChannel, timeoutHeight);

        return true;//TODO return true if sent OK - interfaz
    }

}
