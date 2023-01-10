{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = github:pta2002/nixvim;
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;
  in {
#    homeManagerConfigurations = {
#      emaleth = home-manager.lib.homeManagerConfiguration {
#        inherit system pkgs;
#        username = "emaleth";
#        homeDirectory = "/home/emaleth";
#        configuration = {
#          imports = [
#            .config/nixpkgs/home.nix
#          ];
#        };
#      };
#    };

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emaleth = import ./home.nix;
          }
        ];
      };
    };
  };
 }
