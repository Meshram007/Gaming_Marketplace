// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GamingMarketplace
 * @dev A decentralized marketplace contract for buying and selling NFTs using a custom ERC20 token.
 */
contract GamingMarketplace is Ownable {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingId;

    event ListingCreated(uint256 listingId, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NFTBought(uint256 listingId, address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price);

    modifier onlyActiveListing(uint256 _listingId) {
        require(listings[_listingId].active, "Listing is not active");
        _;
    }

    /**
     * @dev Creates a new listing for selling an NFT.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The token ID of the NFT.
     * @param price The price at which the NFT is listed.
     */
    function createListing(address nftContract, uint256 tokenId, uint256 price) external {
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        listings[listingId] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            price: price,
            active: true
        });

        emit ListingCreated(listingId, nftContract, tokenId, price);
        listingId++;
    }

    /**
     * @dev Allows a seller to list an NFT for sale.
     * @param nftContract The address of the NFT contract.
     * @param tokenId The token ID of the NFT.
     * @param price The price at which the NFT is listed.
     */
    function sellNFT(address nftContract, uint256 tokenId, uint256 price) external {
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        listings[listingId] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            price: price,
            active: true
        });

        emit ListingCreated(listingId, nftContract, tokenId, price);
        listingId++;
    }

    /**
     * @dev Buys an NFT from the marketplace.
     * @param listingId The ID of the listing representing the NFT.
     */
    function buyNFT(uint256 listingId) external onlyActiveListing(listingId) {
        Listing storage listing = listings[listingId];
        
        IERC20 customToken = IERC20(owner()); // Assuming the marketplace owner is holding the custom ERC20 token
        require(customToken.transferFrom(msg.sender, listing.seller, listing.price), "Transfer failed");

        IERC721(listing.nftContract).transferFrom(address(this), msg.sender, listing.tokenId);

        listing.active = false;
        delete listings[listingId];

        emit NFTBought(listingId, msg.sender, listing.nftContract, listing.tokenId, listing.price);
    }
    
    /**
     * @dev Allows a seller to cancel a listing and retrieve their NFT.
     * @param listingId The ID of the listing representing the NFT.
     */
    function cancelListing(uint256 listingId) external onlyActiveListing(listingId) {
        Listing storage listing = listings[listingId];
        require(msg.sender == listing.seller, "Only the seller can cancel the listing");
        
        IERC721(listing.nftContract).transferFrom(address(this), msg.sender, listing.tokenId);
        
        listing.active = false;
        delete listings[listingId];
    }
}
