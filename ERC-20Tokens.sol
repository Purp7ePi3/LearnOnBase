// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

// ERC20-based contract for weighted voting
contract WeightedVoting is ERC20 {
    // Errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    mapping(address => bool) public tokensClaimed;

    using EnumerableSet for EnumerableSet.AddressSet;

    // Struct for issue details
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 quorum;
        uint256 totalVotes;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        bool passed;
        bool closed;
    }

    // Struct for serialized issue details
    struct IssueReturn {
        address[] voters;
        string issueDesc;
        uint256 quorum;
        uint256 totalVotes;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        bool passed;
        bool closed;
    }

    // Enum for vote types
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    Issue[] internal issues;

    uint256 public maxSupply = 1_000_000;
    uint256 public claimAmount = 100;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        issues.push(); // Initialize with an empty issue
    }

    function claim() public {
        if (totalSupply() + claimAmount > maxSupply) revert AllTokensClaimed();
        if (tokensClaimed[msg.sender]) revert TokensClaimed();

        _mint(msg.sender, claimAmount);
        tokensClaimed[msg.sender] = true;
    }

    function createIssue(string calldata _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();
        if (_quorum > totalSupply()) revert QuorumTooHigh();

        Issue storage _issue = issues.push();
        _issue.issueDesc = _issueDesc;
        _issue.quorum = _quorum;
        return issues.length - 1;
    }

    function getIssue(uint256 _issueId) external view returns (IssueReturn memory) {
        Issue storage _issue = issues[_issueId];
        return IssueReturn({
            voters: _issue.voters.values(),
            issueDesc: _issue.issueDesc,
            quorum: _issue.quorum,
            totalVotes: _issue.totalVotes,
            votesFor: _issue.votesFor,
            votesAgainst: _issue.votesAgainst,
            votesAbstain: _issue.votesAbstain,
            passed: _issue.passed,
            closed: _issue.closed
        });
    }

    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage _issue = issues[_issueId];

        if (_issue.closed) revert VotingClosed();
        if (_issue.voters.contains(msg.sender)) revert AlreadyVoted();

        uint256 nTokens = balanceOf(msg.sender);
        if (nTokens == 0) revert NoTokensHeld();

        if (_vote == Vote.AGAINST) _issue.votesAgainst += nTokens;
        else if (_vote == Vote.FOR) _issue.votesFor += nTokens;
        else _issue.votesAbstain += nTokens;

        _issue.voters.add(msg.sender);
        _issue.totalVotes += nTokens;

        if (_issue.totalVotes >= _issue.quorum) {
            _issue.closed = true;
            if (_issue.votesFor > _issue.votesAgainst) {
                _issue.passed = true;
            }
        }
    }
}
