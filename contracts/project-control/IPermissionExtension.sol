// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

interface IPermissionExtension {
    function hasPermission(address addr, uint project, bytes32 role) external view returns(bool);
}