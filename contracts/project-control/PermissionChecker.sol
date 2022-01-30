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
    modifier hasAccess(uint projectId, bytes32 permission) virtual {
        require(projects.hasPermission(permission, msg.sender, projectId), "Sender doesn't have permission!");
        _;
    }

    /**
     * user - the user whose permissions you are checking
     * projectId - the id of the project that you're checking against
     * permission - the specific permission that you're checking against
     */
    modifier userHasAccess(address user, uint projectId, bytes32 permission) virtual {
        require(projects.hasPermission(permission, user, projectId), "Specific user doesn't have permission!");
        _;
    }
}