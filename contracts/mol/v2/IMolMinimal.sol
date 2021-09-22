// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.6.12;

/// @notice Brief interface for Moloch DAO v2. 
interface IMolMinimal { 
    function getProposalFlags(uint256 proposalId) external view returns (bool[6] memory);
    
    function submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        string calldata details
    ) external returns (uint256);
    
    function getProposalFlags(uint256 proposalId) external view returns (bool[6] memory);
}
