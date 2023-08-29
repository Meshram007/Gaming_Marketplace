// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title GamingToken
 * @dev An ERC20 token contract representing the Gaming Token (GT).
 * The token is minted to the contract deployer during deployment.
 */
contract GamingToken is ERC20 {
    /**
     * @dev Constructor function to initialize the GamingToken contract.
     * @param name The name of the token.
     * @param symbol The symbol of the token.
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mint initial supply to contract deployer
    }
}
