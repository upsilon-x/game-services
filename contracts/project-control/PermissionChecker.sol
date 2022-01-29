// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "./ProjectNFT.sol";

abstract contract PermissionChecker {

    ProjectNFT public projects;

    constructor(ProjectNFT _projects) {
        projects = _projects;
    }

    /**
     * projectId - the id of the project that you're checking against
     * permission - the specific permission that you're checking against
     */
    modifier hasAccess(uint projectId, bytes32 permission) {
        require(projects.hasPermission(msg.sender, projectId, permission), "Doesn't have permission!");
        _;
    }
}