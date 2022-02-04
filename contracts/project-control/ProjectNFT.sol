// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./ProjectAccess.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";

/**
 * Owner of a ProjectNFT will have control of a project.
 * This way, a developer can easily transfer or even sell control of a game project in a
 * decentralized and trustless manner.
 * The owner may be set to a smart contract to limit the quality of projects on the platform.
 * This may come in a utility token fee, a greenlight DAO, or some other solution.
 * Initially, the platform will have this restriction turned off. Control of this aspect may be
 * decentralized in the future.
 */
contract ProjectNFT is ERC721Enumerable, Ownable {
    bytes32 constant ADMIN = 0x00;
    bool public restrictMinter = false;
    mapping(uint256 => IPermissionExtension) permissions;

    constructor() ERC721("UpsilonX Game Project", "UPSX-PROJ") Ownable() {}

    /**
     * Mints a new project NFT. If restrictMinter is true, then only the operator can mint projects.
     */
    function mintProject(address to) external returns (uint256) {
        if (restrictMinter) require(msg.sender == owner());
        uint256 nextId = totalSupply();
        _safeMint(to, nextId);
        permissions[nextId] = new ProjectAccess(to);
        return nextId;
    }

    /**
     * Enables or disables the minter restriction to the operator.
     * Only the operator account can do this.
     */
    function setMinterRestriction(bool newRestriction) external onlyOwner {
        restrictMinter = newRestriction;
    }

    /**
     * Sets the permission logic of a project.
     */
    function setAccessControl(
        IAccessControl newAccessControl,
        uint256 projectNFT
    ) external {
        require(
            hasPermission(msg.sender, ADMIN, projectNFT),
            "Only an admin has the ability to change permission logic."
        );
        permissions[projectNFT] = newPermissionExtension;
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
        bytes32 role,
        uint256 project
    ) public view returns (bool) {
        if (ownerOf(project) == addr) {
            return true;
        } else {
            IPermissionExtension perm = permissions[project];
            return
                address(perm) == address(0)
                    ? false
                    : perm.hasRole(role, addr);
        }
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a > b ? b : a;
    }
}
