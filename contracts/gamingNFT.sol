// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GamingNFT is ERC721URIStorage, Ownable {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    /**
     * @dev Mints a new NFT and assigns it to the specified recipient.
     * @param recipient The address that will own the newly minted NFT.
     * @param tokenId The unique identifier for the new NFT.
     * @param tokenURI The metadata URI for the new NFT.
     */
    function mintNFT(address recipient, uint256 tokenId, string memory tokenURI) external onlyOwner {
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
}
