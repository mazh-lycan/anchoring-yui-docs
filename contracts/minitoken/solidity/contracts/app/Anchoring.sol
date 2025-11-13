// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "@hyperledger-labs/yui-ibc-solidity/contracts/apps/commons/IBCAppBase.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IBCHandler.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";
import "../lib/Packet.sol";

contract Anchoring is IBCAppBase {
    IBCHandler ibcHandler;

    using BytesLib for *;

    address private owner;

    mapping (address => bytes32) private userHash;
    mapping (bytes32 => address) private hashUser;

    constructor(IBCHandler ibcHandler_) {
        owner = msg.sender;

        ibcHandler = ibcHandler_;
    }

    event SendTransfer(
        address indexed from,
        address indexed to,
        string sourcePort,
        string sourceChannel,
        uint64 timeoutHeight,
        bytes toanchor
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "MiniToken: caller is not the owner");
        _;
    }

    function ibcAddress() public view override returns (address) {
        return address(ibcHandler);
    }

    function anchorHolderHash(address _holder, bytes32 _hash) internal returns(bool){
        userHash[_holder] = _hash;
        hashUser[_hash] = _holder;
        return true;
    }

    function getHashAnchored(address _holder) external view returns(bytes32){
        return userHash[_holder];
    }


    function sendTransfer(
        bytes memory toanchor,
        address receiver,
        string calldata sourcePort,
        string calldata sourceChannel,
        uint64 timeoutHeight
    ) external {

        _sendPacket(
            IBCPacketData.Data({
                message: toanchor,
                sender: abi.encodePacked(msg.sender),
                receiver: abi.encodePacked(receiver)
            }),
            sourcePort,
            sourceChannel,
            timeoutHeight
        );
        emit SendTransfer(
            msg.sender,
            receiver,
            sourcePort,
            sourceChannel,
            timeoutHeight,
            toanchor
        );
    }

    /// Module callbacks ///

    function onRecvPacket(Packet.Data calldata packet, address /*relayer*/)
        external
        virtual
        override
        onlyIBC
        returns (bytes memory acknowledgement)
    {
        IBCPacketData.Data memory data = IBCPacketData.decode(
            packet.data
        );

        (address holder, bytes32 hash) = abi.decode(bytes(data.message), (address, bytes32));

        return _newAcknowledgement(anchorHolderHash(holder, hash));
    }

    function onAcknowledgementPacket(
        Packet.Data calldata packet,
        bytes calldata acknowledgement,
        address /*relayer*/
    ) external virtual override onlyIBC {
        if (!_isSuccessAcknowledgement(acknowledgement)) {
            bool noack = false;
        }
    }

    function onChanOpenInit(
        Channel.Order,
        string[] calldata connectionHops,
        string calldata portId,
        string calldata channelId,
        ChannelCounterparty.Data calldata counterparty,
        string calldata version
    ) external virtual override {}

    function onChanOpenTry(
        Channel.Order,
        string[] calldata connectionHops,
        string calldata portId,
        string calldata channelId,
        ChannelCounterparty.Data calldata counterparty,
        string calldata version,
        string calldata counterpartyVersion
    ) external virtual override {}

    function onChanOpenAck(
        string calldata portId,
        string calldata channelId,
        string calldata counterpartyVersion
    ) external virtual override {}

    function onChanOpenConfirm(
        string calldata portId,
        string calldata channelId
    ) external virtual override {}

    function onChanCloseConfirm(
        string calldata portId,
        string calldata channelId
    ) external virtual override {}

    function onChanCloseInit(
        string calldata portId,
        string calldata channelId
    ) external virtual override {}

    // Internal Functions //

    function _sendPacket(
        IBCPacketData.Data memory data,
        string memory sourcePort,
        string memory sourceChannel,
        uint64 timeoutHeight
    ) internal virtual {
        ibcHandler.sendPacket(
            sourcePort,
            sourceChannel,
            Height.Data({
                revision_number: 0,
                revision_height: timeoutHeight
            }),
            0,
            IBCPacketData.encode(data)
        );
    }

    function _newAcknowledgement(bool success)
        internal
        pure
        virtual
        returns (bytes memory)
    {
        bytes memory acknowledgement = new bytes(1);
        if (success) {
            acknowledgement[0] = 0x01;
        } else {
            acknowledgement[0] = 0x00;
        }
        return acknowledgement;
    }

    function _isSuccessAcknowledgement(bytes memory acknowledgement)
        internal
        pure
        virtual
        returns (bool)
    {
        require(acknowledgement.length == 1);
        return acknowledgement[0] == 0x01;
    }

}
