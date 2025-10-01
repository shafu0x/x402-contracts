-include .env

.PHONY: build test b t

b: build
t: test

build:
	forge build

test:
	forge test --fork-url ${SEPOLIA_RPC} -vvvv