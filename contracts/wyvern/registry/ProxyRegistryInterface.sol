// SPDX-License-Identifier: Apache-2.0
/*

  Proxy registry interface.

*/

pragma solidity ^0.8.11;

import "./OwnableDelegateProxy.sol";

/**
 * @title ProxyRegistryInterface
 * @author Wyvern Protocol Developers
 */
interface ProxyRegistryInterface {

    function delegateProxyImplementation() external returns (address);

    function proxies(address owner) external returns (OwnableDelegateProxy);

}
