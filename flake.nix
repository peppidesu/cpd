{
  description = "Haskell dev shell for self-contained single-file assignments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs:
        let
          hp = pkgs.haskellPackages;
          # Add libraries here if the judge provides them (e.g. containers, vector).
          ghc = hp.ghcWithPackages (ps: with ps; [
            containers
            array
            vector
            mtl
          ]);
        in
        {
          default = pkgs.mkShell {
            packages = [
              ghc
              hp.haskell-language-server
              hp.hlint
              hp.ormolu
            ];
          };
        });
    };
}
