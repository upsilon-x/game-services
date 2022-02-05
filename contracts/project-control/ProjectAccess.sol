// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * The default way of defining project access.
 */
contract ProjectAccess is AccessControl {
    function hasRole(bytes32 role, address addr)
        public
        view
        override
        returns (bool)
    {
        return super.hasRole(role, addr);
    }

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }
}