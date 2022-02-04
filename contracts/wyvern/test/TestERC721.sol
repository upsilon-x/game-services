// SPDX-License-Identifier: Apache-2.0
/*

  << TestERC721 >>

*/

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TestERC721 is ERC721("test", "TST") {

    /**
     */
    constructor () public {
        mint(msg.sender, 1);
        mint(msg.sender, 2);
        mint(msg.sender, 3);
    }

    /**
     */
    function mint(address to, uint256 tokenId) public returns (bool) {
        _mint(to, tokenId);
        return true;
    }

}
