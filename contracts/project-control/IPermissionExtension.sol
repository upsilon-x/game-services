// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

interface IPermissionExtension {
    function hasRole(bytes32 role, address addr) external view returns(bool);
}