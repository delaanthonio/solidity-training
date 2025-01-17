// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//interface of a OpenSea compliant contract
import "./interfaces/IERC721OpenSea.sol";

/**
 * @dev Abstract of an OpenSea compliant contract
 */
abstract contract ERC721OpenSea is IERC721OpenSea {
    string private _baseTokenURI;
    string private _contractURI;

    /**
     * @dev The base URI for token data ex. https://creatures-api.opensea.io/api/creature/
     * Example Usage:
     *  Strings.strConcat(baseTokenURI(), Strings.uint2str(tokenId))
     */
    function baseTokenURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev The URI for contract data ex. https://creatures-api.opensea.io/contract/opensea-creatures
     * Example Format:
     * {
     *   "name": "OpenSea Creatures",
     *   "description": "OpenSea Creatures are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.",
     *   "image": "https://openseacreatures.io/image.png",
     *   "external_link": "https://openseacreatures.io",
     *   "seller_fee_basis_points": 100, # Indicates a 1% seller fee.
     *   "fee_recipient": "0xA97F337c39cccE66adfeCB2BF99C1DdC54C2D721" # Where seller fees will be paid to.
     * }
     */
    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    /**
     * @dev Setting base token uri would be acceptable if using IPFS CIDs
     */
    function _setBaseTokenURI(string memory uri) internal virtual {
        _baseTokenURI = uri;
    }

    /**
     * @dev Sets contract
     */
    function _setContractURI(string memory uri) internal virtual {
        _contractURI = uri;
    }
}
