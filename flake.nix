{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, home-manager, impermanence, sops-nix, nixvim, stylix, ...}: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emaleth = {
            #import ./home.nix;
              imports = [
                #impermanence.homeManagerModules.impermanence
                sops-nix.homeManagerModules.sops
                nixvim.homeModules.nixvim
                ./home.nix
              ];
            };
          }
          #impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          nixvim.nixosModules.nixvim
          stylix.nixosModules.stylix
        ];
      };   
    };
  };
}
