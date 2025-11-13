// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAnchoring{

    /// @dev Emit when data is sent to anchor on blockchain B
    /// @param from The address of the Smart Contract to be anchored
    /// @param to The address of who wants to anchor the information
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
    /// @param receiver The address of who wants to anchor the information
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


}