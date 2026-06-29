{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    noctalia = {
      #url = "github:noctalia-dev/noctalia/cachix";
      url = "github:noctalia-dev/noctalia/6d6d8a506558ac3a1dc558bd3262d16157a890ef";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };
    niri ={
      url = "github:sodiboo/niri-flake";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };

  outputs = inputs @ {nixpkgs, noctalia, noctalia-greeter, niri, impermanence, nvf, ...}: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
    	  system = "x86_64-linux";
        modules = [
          ./configuration.nix
      	  noctalia-greeter.nixosModules.default
          niri.nixosModules.niri
          impermanence.nixosModules.impermanence
	        nvf.nixosModules.default
        ];
      };   
    };
  };
}
