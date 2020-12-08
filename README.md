# ds-test-blog-examples

This contains example code for the ethereum fv team blog post on symbolic execution with ds-test.

In order to run these tests, you need first [install nix](https://nixos.org/download.html). Once
installed you can enter a shell with all dependencies prepared by running the following:

```
# make prebuilt hevm binaries available to nix
cachix use dapp

# enter the nix shell
nix-shell
```

### Running Tests

```
# Associativity tests
dapp test --match TestAdd

# Token transfer tests
dapp test --match TestToken

# Balancer transfer tests
DAPP_TEST_ADDRESS=0xb618f903ad1d00d6f7b92f5b0954dcdc056fc533 dapp test --rpc-url <URL> --match TestBal
```
