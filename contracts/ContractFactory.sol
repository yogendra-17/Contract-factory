// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Counter.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./SimpleAccount.sol";


contract CounterFactory 
{
    Counter[] public deployedCounters;

    address public immutable implementation;

    constructor() {
      implementation = address(new Counter()); 
    }

    event CounterDepps(address _counterAddress);

    function depCount(uint256 _initialCounter) public {
        address payable clone = payable(Clones.clone(implementation));
        Counter counter = Counter(clone);
        counter.initialize(_initialCounter);

        deployedCounters.push(counter);
        emit CounterDepps(address(counter));
    }
}

contract SimpleAccountFactory {
    SimpleAccount public immutable accountImplementation;

    constructor(IEntryPoint _entryPoint) {
        accountImplementation = new SimpleAccount(_entryPoint);
    }

    /**
     * create an account, and return its address.
     * returns the address even if the account is already deployed.
     * Note that during UserOperation execution, this method is called only if the account is not deployed.
     * This method returns an existing account address so that entryPoint.getSenderAddress() would work even after account creation
     */
    event SimpleAccountCreated(address _address);
    function createAccount(address owner,uint256 salt) public returns (SimpleAccount ret) {
        address addr = getAddress(owner, salt);
        uint codeSize = addr.code.length;
        if (codeSize > 0) {
            return SimpleAccount(payable(addr));
        }
        ret = SimpleAccount(payable(new ERC1967Proxy{salt : bytes32(salt)}(
                address(accountImplementation),
                abi.encodeCall(SimpleAccount.initialize, (owner))
            )));
    }

    /**
     * calculate the counterfactual address of this account as it would be returned by createAccount()
     */
    function getAddress(address owner,uint256 salt) public view returns (address) {
        return Create2.computeAddress(bytes32(salt), keccak256(abi.encodePacked(
                type(ERC1967Proxy).creationCode,
                abi.encode(
                    address(accountImplementation),
                    abi.encodeCall(SimpleAccount.initialize, (owner))
                )
            )));
    }
}