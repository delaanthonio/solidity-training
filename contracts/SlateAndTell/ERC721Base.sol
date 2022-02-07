// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./BEP721/BEP721.sol";
import "./OpenSea/ERC721OpenSea.sol";

abstract contract ERC721Base is
    Context,
    Ownable,
    AccessControlEnumerable,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721Pausable,
    ERC721URIStorage,
    BEP721,
    ERC721OpenSea
{
    //we will be enumerating the token ids
    using Counters for Counters.Counter;

    //all possible roles
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant CURATOR_ROLE = keccak256("CURATOR_ROLE");

    Counters.Counter private _tokenIdTracker;

    /**
     * @dev Returns the current id index
     */
    function lastId() public view virtual returns (uint256) {
        return _tokenIdTracker.current();
    }

    /**
     * @dev override; super defined in ERC721; Specifies the name by
     * which other contracts will recognize the BEP-721 token
     */
    function name()
        public
        view
        virtual
        override(IBEP721, ERC721)
        returns (string memory)
    {
        return super.name();
    }

    /**
     * @dev Pauses all token transfers.
     */
    function pause() public virtual onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @dev override; super defined in ERC721; A concise name for the token,
     *      comparable to a ticker symbol
     */
    function symbol()
        public
        view
        virtual
        override(IBEP721, ERC721)
        returns (string memory)
    {
        return super.symbol();
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Shows the overall amount of tokens generated in the contract
     */
    function totalSupply()
        public
        view
        virtual
        override(BEP721, ERC721Enumerable)
        returns (uint256)
    {
        return super.totalSupply();
    }

    /**
     * @dev Unpauses all token transfers.
     */
    function unpause() public virtual onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerable, ERC721, IERC165, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Describes linear override for `_beforeTokenTransfer` used in
     * both `ERC721Enumerable` and `ERC721Pausable`
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     */
    function _safeMint(address to) internal virtual {
        //from zero to one
        _tokenIdTracker.increment();
        // We cannot just use balanceOf to create the new tokenId because tokens
        // can be burned (destroyed), so we need a separate counter.
        _safeMint(to, lastId());
        _addSupply(1);
    }
}
