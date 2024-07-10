{
  description = "Charly's beancount dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Personal beancount plugins and scripts.
    edamame.url = "git+ssh://git@github.com/0xcharly/edamame";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    edamame,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # Inject the `edamame` python module into the package repository.
      pkgs = import nixpkgs {
        inherit system;
        overlays = [edamame.overlays.default];
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          # Support for beancount language features inside editors.
          pkgs.beancount-language-server

          # Python 3.11 distribution with the `edamame` module installed.
          (pkgs.python311.withPackages (ps: [ps.edamame]))
        ];
      };
    });
}
