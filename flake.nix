{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    niri ={
      url = "github:sodiboo/niri-flake";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs = inputs @ {nixpkgs, noctalia, niri, impermanence, nixvim, ...}: {
    nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          #impermanence.nixosModules.impermanence
          nixvim.nixosModules.nixvim
          #./noctalia.nix
        ];
      };   
    };
  };
}
