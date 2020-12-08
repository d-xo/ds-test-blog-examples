// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.6.12;
import {DSTest} from "ds-test/test.sol";

// --- Associativity Tests ---

contract TestAdd is DSTest {
    function test_associativity() public {
        assertEq(
            uint((1 + 2) + 3),
            uint(1 + (2 + 3))
        );
    }

    function test_associativity_fuzz(uint x, uint y, uint z) public {
        assertEq(
            (x + y) + z,
            x + (y + z)
        );
    }

    function prove_associativity(uint x, uint y, uint z) public {
        assertEq(
          (x + y) + z,
          x + (y + z)
        );
    }
}

// --- Token Tests ---

contract SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "underflow");
    }
}

contract Token is SafeMath {
    uint256 public totalSupply;
    mapping (address => uint) public balanceOf;

    constructor(uint _totalSupply) public {
        totalSupply           = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    function transfer(address dst, uint amt) public {
        balanceOf[msg.sender] = sub(balanceOf[msg.sender], amt);
        balanceOf[dst]        = add(balanceOf[dst], amt);
    }
}

// should fail
contract TestToken is DSTest, SafeMath {
    function prove_transfer(address dst, uint amt) public {
        Token token = new Token(uint(-1));

        uint preBalThis = token.balanceOf(address(this));
        uint preBalDst  = token.balanceOf(dst);

        token.transfer(dst, amt);

        // balance of this has been reduced by `amt`
        assertEq(sub(preBalThis, token.balanceOf(address(this))), amt);

        // balance of dst has been increased by `amt`
        assertEq(sub(token.balanceOf(dst), preBalDst), amt);
    }
}

// --- Balancer Token Tests ---

interface ERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TestBal is DSTest, SafeMath {
    function setUp() public {}

    function prove_transfer(address dst, uint amt) public {
        // BAL: https://etherscan.io/address/0xba100000625a3754423978a60c9317c58a424e3D#code
        ERC20 bal = ERC20(0xba100000625a3754423978a60c9317c58a424e3D);

        // ignore cases where we don't have engough tokens
        if (amt > bal.balanceOf(address(this))) return;

        uint preBalThis = bal.balanceOf(address(this));
        uint preBalDst  = bal.balanceOf(dst);

        bal.transfer(dst, amt);

        // no change for self-transfer
        uint delta = dst == address(this) ? 0 : amt;

        // balance of `this` has been reduced by `delta`
        assertEq(sub(preBalThis, delta), bal.balanceOf(address(this)));

        // balance of `dst` has been increased by `delta`
        assertEq(add(preBalDst, delta), bal.balanceOf(dst));
    }
}
