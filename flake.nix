{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    noctalia = {
      #url = "github:noctalia-dev/noctalia/cachix";
      url = "github:noctalia-dev/noctalia/8de8c875fec545ac61bcc89b55e38b0010afa0d6";
    };
    noctalia-greeter = {
      #url = "github:noctalia-dev/noctalia-greeter";
      url = "github:noctalia-dev/noctalia-greeter/8de8c875fec545ac61bcc89b55e38b0010afa0d6";
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

  nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

}
