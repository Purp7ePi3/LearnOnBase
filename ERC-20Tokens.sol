// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {

    uint256 public maxSupply = 1000000;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    mapping(address => bool) public claimingList;

    using EnumerableSet for EnumerableSet.AddressSet;

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool isPassed;
        bool isClosed;
    }

    struct IssueReturn {
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool isPassed;
        bool isClosed;
    }

    Issue[] issues;

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    constructor() ERC20("MyToken", "MTK") {
    }

    function claim() public {
        if (totalSupply() + 100 > maxSupply){
            revert AllTokensClaimed();
        }
        else if (claimingList[msg.sender]){
            revert TokensClaimed();
        }
        _mint(msg.sender, 100);
        claimingList[msg.sender] = true;
    }

    function createIssue(string memory _desc, uint256 _quorum) external returns (uint256 index) {
        if (balanceOf(msg.sender) > 0){

            if (_quorum <= totalSupply()) {
                Issue storage _issue = issues.push();
                _issue.issueDesc = _desc;
                _issue.quorum = _quorum;

                index = issues.length -1;
            } else {
                revert QuorumTooHigh(_quorum);
            }
        } else {
            revert NoTokensHeld();
        }
    }

    function getIssue(uint256 _id) external view returns (IssueReturn memory) {
        if (_id >= issues.length){
            revert("Issue does not exist");
        }

        Issue storage _issue = issues[_id];

        return IssueReturn({
            issueDesc: _issue.issueDesc,
            votesFor: _issue.votesFor,
            votesAgainst: _issue.votesAgainst,
            votesAbstain: _issue.votesAbstain,
            totalVotes: _issue.totalVotes,
            quorum: _issue.quorum,
            isPassed: _issue.isPassed,
            isClosed: _issue.isClosed
        });
    }

    function vote(uint256 _issueId, Vote _vote) public {

        Issue storage _issue = issues[_issueId];

        if(_issue.isClosed){
            revert VotingClosed();
        } else if(_issue.voters.contains(msg.sender)){
            revert AlreadyVoted();
        }

        uint256 allTokens = balanceOf(msg.sender);

        _issue.totalVotes += allTokens;

        if(_vote == Vote.FOR){
            _issue.votesFor += allTokens;
        }else if(_vote == Vote.AGAINST){
            _issue.votesAgainst += allTokens;
        }else if(_vote == Vote.ABSTAIN){
            _issue.votesAbstain += allTokens;
        }

        if(_issue.totalVotes >= _issue.quorum){
            _issue.isClosed = true;
        }if(_issue.votesFor > _issue.votesAgainst){
            _issue.isPassed = true;
        }

        _issue.voters.add(msg.sender);
    }
}