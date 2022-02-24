{
  description = "Emailaddress";
  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, haskellNix, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [
          haskellNix.overlay
          # This overlay adds our project to pkgs
          (final: prev: {
            emailaddress = pkgs.haskell-nix.project {
              src = pkgs.haskell-nix.haskellLib.cleanGit {
                name = "emailaddress";
                src = ./.;
              };
              compiler-nix-name = "ghc8107";
              # For `nix develop` devshell
              shell = {
                buildInputs = with pkgs; [];
                tools = {
                  cabal = {
                    version = "3.2.0.0";
                  };
                  haskell-language-server = {
                    version = "1.5.0.0";
                    cabalProject = ''
                        packages: .
                        package haskell-language-server
                          flags: +rename
                      '';
                  };
                  hindent = {
                    version = "latest";
                  };
                  hpack = {
                    version = "0.34.4";
                  };
                  hlint = {
                    version = "latest";
                  };
                };
                withHoogle = true;
              };
            };
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
        };
        flake = pkgs.emailaddress.flake {};
      in flake // {
        defaultPackage = flake.packages."emailaddress:lib:emailaddress";
      }
    );
}
