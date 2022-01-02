// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
 * Owner of a ProjectNFT will have control of a project.
 * This way, a developer can easily transfer or even sell control of a game project in a
 * decentralized and trustless manner.
 * The operator may be set to a smart contract to limit the quality of projects on the platform. 
 * This may come in a utility token fee, a greenlight DAO, or some other solution.
 * Initially, the platform will have this restriction turned off. Control of this aspect may be 
 * decentralized in the future.
 */
contract ProjectNFT is ERC721Enumerable {
    
    constructor() ERC721("UpsilonX Game Project", "UPSX-PROJ") {
        operator = msg.sender;
    }
    
    address public operator;
    bool public restrictMinter = false;

    /**
     * Mints a new project NFT. If restrictMinter is true, then only the operator can mint projects.
     */
    function mintProject(address to) external returns(uint) {
        if(restrictMinter) 
            require(msg.sender == operator);
        uint nextId = totalSupply();
        _safeMint(to, nextId);
        return nextId;
    }

    /**
     * Enables or disables the minter restriction to the operator. 
     * Only the operator account can do this.
     */
    function setMinterRestriction(bool newRestriction) external {
        require(msg.sender == operator);
        restrictMinter = newRestriction;
    }

    /**
     * Sets the operator of the contract.
     * Only the operator account can do this.
     */
    function setOperator(address newOperator) external {
        require(msg.sender == operator);
        operator = newOperator;
    }



    /**
     * Returns all of the tokens of an owner, so that read requests are minimized.
     * https://forum.openzeppelin.com/t/expose-tokensofowner-method-on-erc721enumerable/888/8
     */
    function tokensOfOwnerPaginated(
        address owner,
        uint8 page,
        uint8 rows
    ) public view returns (uint[] memory) {
        require(rows > 0, "_rows should be greater than 0");

        uint _tokenCount = balanceOf(owner);
        uint _offset = page * rows;
        uint _range = _offset > _tokenCount
            ? 0
            : min(_tokenCount - _offset, rows);

        uint[] memory _tokens = new uint[](_range);
        for (uint i = 0; i < _range; i++) {
            _tokens[i] = tokenOfOwnerByIndex(owner, _offset + i);
        }
        return _tokens;
    }

    function min(uint a, uint b) private pure returns (uint) {
        return a > b ? b : a;
    }
}
