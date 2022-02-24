.PHONY: build build-haddock clean ghci haddock haddock-server lint repl test watch watch-tests watch-test
all: build

clean:
	cabal new-clean

build: 
	cabal new-build

haddock: build-haddock
build-haddock:
	cabal new-haddock

# Run ghci using stack.
repl: ghci
ghci:
	cabal new-repl

test:
	cabal new-test

# Run hlint.
lint:
	hlint src/
