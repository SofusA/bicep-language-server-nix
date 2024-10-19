{
  description = "A simple derivation for bicep language server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
       
        bicepLangServer = pkgs.stdenv.mkDerivation rec {
          pname = "bicep-langserver";
          version = "0.30.23";

          src = pkgs.fetchzip {
            url = "https://github.com/Azure/bicep/releases/download/v${version}/bicep-langserver.zip";
            sha256 = "sha256-aZ9ybx0a6wOg+p34UPwSfynXqSGR5X4Ko6aGMA64b2Y=";
            stripRoot = false;
          };
          
          installPhase = ''
            mkdir -p $out/bin
            cp -r $src $out/bin/Bicep.LangServer/

            cat <<EOF > $out/bin/bicep-langserver
            #!/usr/bin/env bash
            exec dotnet $out/bin/Bicep.LangServer/Bicep.LangServer.dll "\$@"
            EOF
  
            # Make the script executable
            chmod +x $out/bin/bicep-langserver
          
          '';
        };
      
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            bicepLangServer
          ];
        };
        
        packages.bicep-langserver = bicepLangServer;
      });
}
