{
  description = "My GHC Flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };
  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extensions = (with pkgs.vscode-extensions; [
            bbenoist.nix
            haskell.haskell
            justusadam.language-haskell
          ]);
          vscodium-with-extensions = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = extensions;
          };
      in pkgs.mkShell {
        buildInputs = [
          (pkgs.ghc.withPackages (ps: with ps; [ implicit ]))
          pkgs.meshlab
          pkgs.xdotool
          pkgs.inotify-tools
          vscodium-with-extensions
          pkgs.haskell-language-server
        ];
      };
  };
}
