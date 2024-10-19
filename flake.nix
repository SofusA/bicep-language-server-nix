{
  description = "A simple derivation for bicep language server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.bash
            pkgs.unzip
            (pkgs.writeShellScriptBin "bicep-langserver" ''
              exec dotnet $PWD/.bicep-langserver/Bicep.LangServer.dll
            '')
          ];

          src = pkgs.fetchurl {
            url = "https://github.com/Azure/bicep/releases/download/v0.30.23/bicep-langserver.zip";
            sha256 = "sha256-J+GQfAWizDIb1vonqhKkA11C7bhNfPzCKZpYfFl3qxw=";
          };

          installPhase = ''
            mkdir -p $PWD/.bicep-langserver
            cd $PWD/.bicep-langserver

            unzip $src
          '';
        };
      });
}
