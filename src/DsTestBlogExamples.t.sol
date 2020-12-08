pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./DsTestBlogExamples.sol";

contract DsTestBlogExamplesTest is DSTest {
    DsTestBlogExamples examples;

    function setUp() public {
        examples = new DsTestBlogExamples();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
