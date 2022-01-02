// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IPermissionExtension.sol";

/**
 * Owner of a ProjectNFT will have control of a project.
 * This way, a developer can easily transfer or even sell control of a game project in a
 * decentralized and trustless manner.
 * The operator may be set to a smart contract to limit the quality of projects on the platform.
 * This may come in a utility token fee, a greenlight DAO, or some other solution.
 * Initially, the platform will have this restriction turned off. Control of this aspect may be
 * decentralized in the future.
 */
contract ProjectNFT is ERC721Enumerable, IPermissionExtension {
    constructor() ERC721("UpsilonX Game Project", "UPSX-PROJ") {
        operator = msg.sender;
    }

    address public operator;
    bool public restrictMinter = false;
    IPermissionExtension permissions;

    /**
     * Mints a new project NFT. If restrictMinter is true, then only the operator can mint projects.
     */
    function mintProject(address to) external returns (uint256) {
        if (restrictMinter) require(msg.sender == operator);
        uint256 nextId = totalSupply();
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
     * Sets the permission extension of the contract.
     * Only the operator account can do this.
     */
    function setPermissionExtension(IPermissionExtension newPermissionExtension)
        external
    {
        require(msg.sender == operator);
        permissions = newPermissionExtension;
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
    ) public view returns (uint256[] memory) {
        require(rows > 0, "_rows should be greater than 0");

        uint256 _tokenCount = balanceOf(owner);
        uint256 _offset = page * rows;
        uint256 _range = _offset > _tokenCount
            ? 0
            : min(_tokenCount - _offset, rows);

        uint256[] memory _tokens = new uint256[](_range);
        for (uint256 i = 0; i < _range; i++) {
            _tokens[i] = tokenOfOwnerByIndex(owner, _offset + i);
        }
        return _tokens;
    }

    function hasPermission(
        address addr,
        uint256 project,
        bytes32 role
    ) public view returns (bool) {
        if (ownerOf(project) == addr) {
            return true;
        } else {
            return
                address(permissions) == address(0)
                    ? false
                    : permissions.hasPermission(addr, project, role);
        }
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a > b ? b : a;
    }
}
