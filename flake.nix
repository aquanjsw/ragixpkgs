{
  description = "Shin Rag's Nixpkgs Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      overlay = import ./overlay.nix;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
        inherit (flake-utils.lib) mkApp;
      in
      {
        packages = {
          inherit (pkgs) propertree;
        };
        apps = {
          propertree = mkApp { drv = pkgs.propertree; };
        };
        devShells.default = import ./shell.nix { inherit pkgs; };
      }
    )
    // {
      overlays.default = overlay;
    };
}
