// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "./IPermissionExtension.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * The default way of defining project access.
 */
contract ProjectAccess is IPermissionExtension, AccessControl {
    function hasRole(bytes32 role, address addr)
        public
        view
        override(AccessControl, IPermissionExtension)
        returns (bool)
    {
        return super.hasRole(role, addr);
    }

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }
}
