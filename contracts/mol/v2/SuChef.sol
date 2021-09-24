// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.6.12;

import "./interfaces/IMolMinimal.sol";
import "../../utils/ReentrancyGuard.sol";

/// @notice Low-level caller, ETH/NFT holder, separate bank for Moloch DAO v2 - based on Raid Guild `Minion`.
contract SuChef is ReentrancyGuard {
    address immutable depositToken;
    IMolMinimal public moloch; // parent moloch contract reference 

    mapping(uint256 => Action) public actions; // proposalId => Action

    struct Action {
        uint256 value;
        address to;
        address proposer;
        bool executed;
        bytes data;
    }

    event ProposeAction(uint256 proposalId, address proposer);
    event ExecuteAction(uint256 proposalId, address executor);

    constructor(address _depositToken, IMolMinimal _moloch) public {
        depositToken = _depositToken;
        moloch = _moloch;
    }

    function doWithdraw(address token, uint256 amount) external nonReentrant {
        moloch.withdrawBalance(token, amount); // withdraw funds from parent moloch into minion
    }

    function proposeAction(
        address actionTo,
        uint256 actionValue,
        bytes calldata actionData,
        string calldata details
    ) external nonReentrant returns (uint256) {
        // No calls to zero address allows us to check that proxy submitted
        // the proposal without getting the proposal struct from parent moloch
        require(actionTo != address(0), "invalid actionTo");

        uint256 proposalId = moloch.submitProposal(
            address(this),
            0,
            0,
            0,
            depositToken,
            0,
            depositToken,
            details
        );

        Action memory action = Action({
            value: actionValue,
            to: actionTo,
            proposer: msg.sender,
            executed: false,
            data: actionData
        });

        actions[proposalId] = action;

        emit ProposeAction(proposalId, msg.sender);
        return proposalId;
    }

    function executeAction(uint256 proposalId) external nonReentrant returns (bytes memory) {
        Action memory action = actions[proposalId];
        bool[6] memory flags = moloch.getProposalFlags(proposalId);

        require(action.to != address(0), "invalid proposalId");
        require(!action.executed, "action executed");
        require(address(this).balance >= action.value, "insufficient ETH");
        require(flags[2], "proposal not passed");

        // execute call
        actions[proposalId].executed = true;
        (bool success, bytes memory retData) = action.to.call{value: action.value}(action.data);
        require(success, "call failure");
        emit ExecuteAction(proposalId, msg.sender);
        return retData;
    }
    
    /// @notice Returns confirmation for 'safe' ERC-721 (NFT) transfers.
    function onERC721Received(address, address, uint, bytes calldata) external pure returns (bytes4 sig) {
        sig = 0x150b7a02; /*'onERC721Received(address,address,uint,bytes)'*/
    }
    
    /// @notice Returns confirmation for 'safe' ERC-1155 transfers.
    function onERC1155Received(address, address, uint, uint, bytes calldata) external pure returns (bytes4 sig) {
        sig = 0xf23a6e61; /*'onERC1155Received(address,address,uint,uint,bytes)'*/
    }
    
    /// @notice Returns confirmation for 'safe' batch ERC-1155 transfers.
    function onERC1155BatchReceived(address, address, uint[] calldata, uint[] calldata, bytes calldata) external pure returns (bytes4 sig) {
        sig = 0xbc197c81; /*'onERC1155BatchReceived(address,address,uint[],uint[],bytes)'*/
    }

    receive() external payable {}
}
