//SPDX-License-Identifier: GLWTPL
pragma solidity ^0.8.7;
/*
* TODOs:
* 1. Set up validator sign-ups - done
* 2. Set up signature validation - might not need to be done
* 3. Implement events 
* 4. Set up validator selection - done
* 5. Implement certificate issuance
* 6. 
*/
contract EthCA {
    //Keeps track of signed up validators
    address payable[] signups;
    mapping (address=>bool) signedup;
    //Keeps track of all requests
    validationRequest[] requests;
    //Keeps track of addresses verified to make certificate changes for domains
    mapping (string => address) verified;
    //trackers for signups and requests
    uint numsignups;
    uint numRequests;
    uint constant numValidators = 20;
    uint constant quorum = 8;
    //struct to contain information needed in validation requests
    struct validationRequest {
        uint id;
        uint nonce;
        mapping (address => bool) validators;
        address payable[numValidators] validatorlist;
        address payable[numValidators] yesNodes;
        address payable[numValidators] noNodes;
        string domain;
        address sender;
        uint reward;
        bool completed;
        uint yesVotes;
        uint noVotes;
        uint deadline;
    }
    function chooseValidators(uint id) private {
        for(uint i = 0; i < numValidators; i++) {
            //Generate some value that will not be easily predictable by attacker (definitely not random, but also not easily subject to manipulation)
            uint index = uint(sha256(abi.encodePacked(signups.length))) % signups.length;
            //Pick a validator and remove them from signedup
            address payable val1 = signups[index];
            signedup[val1] = false;
            //Replace the chosen address w/last address in signups
            signups[index] = signups[signups.length - 1];
            //Delete last slot in signups
            signups.pop();
            //Add to validator list
            requests[id].validatorlist[i] = val1;
            //TODO: Add event to track this and *notify* validator
        }
    }
    //Should be the primary call from domain owners wanting a certificate; returns id of created validation request
    //
    function request_verification(string memory domain) public payable returns (uint) {
        require(msg.value >= 10 ether);
        //Generate a nonce that will be posted at the domain for validation
        uint nonce = uint(sha256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, numsignups)));
        //fill out validation request
        requests[numRequests].nonce = nonce;
        requests[numRequests].id = numRequests;
        requests[numRequests].sender = msg.sender;
        requests[numRequests].domain = domain;
        //select validators for request
        chooseValidators(numRequests);
        
     }
    function sign_up() public payable returns (uint) {
        //Require that enough stake money is sent
        require(msg.value == 1 ether, "Sign-up rejected! Inadequate stake value");
        //Require that the sender not already be signed up
        require(signedup[msg.sender] == false, "Already signed up!");
        signups[numsignups] = payable(msg.sender);
        numsignups = numsignups + 1;
        return numsignups - 1;
    }
    //Allow validators to cancel their signup and receive a refund of their stake
    function cancel_signup(uint id) public {
        require(signups[id] == msg.sender, "ID doesn't match your address!");
        require(signedup[msg.sender] == true, "Not signed up!");
        signedup[msg.sender] = false;
        signups[id] = payable(address(0));
        payable(msg.sender).transfer(1 ether);
    }
    //Allow validators to vote on requests they have been selected for
    function vote(uint requestID, bool voteIn) public {
        //Require that the voter has been selected to validate this request
        require(requests[requestID].validators[msg.sender] == true, "Not a validator for this request!");
        //Require that the vote is in time
        require(block.number < requests[requestID].deadline, "Voting has closed");
        //Log vote
        if(voteIn) {
            //Add voter to list of yeasayers then increment count of yes votes
            requests[requestID].yesNodes[requests[requestID].yesVotes] = payable(msg.sender);
            requests[requestID].yesVotes = requests[requestID].yesVotes + 1;
        } else {
            //Add voter to list of naysayers then increment count of no votes
            requests[requestID].noNodes[requests[requestID].noVotes] = payable(msg.sender);
            requests[requestID].noVotes = requests[requestID].noVotes + 1;
        }
        //Send the validator their reward *** need to implement PoS waiting to do this
        payable(msg.sender).transfer(1 ether + requests[requestID].reward);
        //Remove sender from validator list so they can't vote again
        requests[requestID].validators[msg.sender] = false;
    }
    //Function that needs to be called to tally votes and authorize/not authorize this issuance - can be called by validators or requestor
    function endVerification(uint requestID) public {
        //Enforce requirements to complete a verification request - must be involved in request and deadline must be passed
        require(requests[requestID].validators[msg.sender] == true || requests[requestID].sender == msg.sender, "Not authorized to end this verification!");
        require(block.number > requests[requestID].deadline, "Deadline not yet passed!");
        if(requests[requestID].yesVotes + requests[requestID].noVotes >= quorum) {
            if(requests[requestID].yesVotes > requests[requestID].noVotes) {
                //pay the validators
                for(uint i = 0; i < requests[requestID].yesVotes; i++) {
                    requests[requestID].yesNodes[i].transfer(1 ether + requests[requestID].reward);
                }
                //authorize the owner for their domain
                verified[requests[requestID].domain] = requests[requestID].sender;
            } else {
                //pay the validators
                for(uint i = 0; i < requests[requestID].noVotes; i++) {
                    requests[requestID].noNodes[i].transfer(1 ether + requests[requestID].reward);
                }
            }
        } else {
            //Quorum not met - pay validators who voted back their stake, pay owner back however much is left
            //Possible functionality - ban nodes who don't vote from being validators
            
        }
        requests[requestID].completed = true;
    }
    //Function that an authorized address can call to issue a certificate for a given public key for their domain
    function issueCertificate(bytes[] memory publicKey, string memory domain) public {
        
    }
}