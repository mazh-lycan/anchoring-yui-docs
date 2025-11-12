// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAnchoring{

    /// @dev Emit when data is sent to anchor on blockchain B
    /// @param from The address of who wants to anchor the information on Blockchain A (useful for when k1-r1)
    /// @param to The address of who wants to anchor the information on Blockchain B (useful for when k1- r1)
    /// @param sourcePort Port of IBC used in communication through relayer
    /// @param sourceChannel Channel of IBC used in communication through relayer
    /// @param timeoutHeight Timeout height used in communication through relayer
    /// @param toanchor Information sent to be anchored on Blockchain B
    event SendTransfer(
        address indexed from,
        address indexed to,
        string sourcePort,
        string sourceChannel,
        uint64 timeoutHeight,
        bytes toanchor
    );


    /// @dev Function that returns the IBCHandler linked to this anchoring contract on this specific blockchain
    /// @return ibcHandler Address of the linked IBCHandler
    function ibcAddress() external view returns (address);


    /// @dev Function that sends through the IBC the information to anchor
    /// @param toanchor Information sent to be anchored on Blockchain B 
    /// @param receiver The address of who wants to anchor the information on Blockchain B (useful for when k1- r1)
    /// @param sourcePort Port of IBC used in communication through relayer
    /// @param sourceChannel Channel of IBC used in communication through relayer
    /// @param timeoutHeight Timeout height used in communication through relayer
    function sendTransfer(
        bytes memory toanchor,
        address receiver,
        string calldata sourcePort,
        string calldata sourceChannel,
        uint64 timeoutHeight
    ) external;


    /// @dev Function that receives on the anchoring blockchain (Blockchain B) the information to anchor, and unpacks it
    /// @param packet The information to anchor, packed
    /// @param address DEPRECATED address on-chain IBC component
    function onRecvPacket(Packet.Data calldata packet, address relayer)
        external
        virtual
        override
        onlyIBC
        returns (bytes memory acknowledgement)


}