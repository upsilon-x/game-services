// SPDX-License-Identifier: Apache-2.0
/**

  << TestAuthenticatedProxy >>

  Just for DelegateCall testing.

**/

pragma solidity ^0.8.11;

import "../registry/AuthenticatedProxy.sol";

contract TestAuthenticatedProxy is AuthenticatedProxy {

    function setUser(address newUser)
        public
    {
        registry.transferAccessTo(user, newUser);
        user = newUser;
    }

}
