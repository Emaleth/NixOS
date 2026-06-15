{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = inputs @ {nixpkgs, noctalia, noctalia-greeter, niri, impermanence, nixvim, ...}: {
    nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
	system = "x86_64-linux";
        modules = [
          ./configuration.nix
	  noctalia-greeter.nixosModules.default
          niri.nixosModules.niri
          #impermanence.nixosModules.impermanence
          nixvim.nixosModules.nixvim
        ];
      };   
    };
  };
}
