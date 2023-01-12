{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    home-manager = {
      url = github:nix-community/home-manager/release-22.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = github:pta2002/nixvim;
    stylix.url = github:danth/stylix;
#    base16-schemes.url = github:tinted-theming/base16-schemes;
  };

  outputs = { nixpkgs, home-manager, nixvim, stylix, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

    base16-schemes = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "base16-schemes";
      rev = "cf6bc892a24af19e11383adedc6ce7901f133ea7";
      sha256 = "sha256-U9pfie3qABp5sTr3M9ga/jX8C807FeiXlmEZnC4ZM58=";
    };
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit nixvim stylix base16-schemes; 
        };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emaleth = import ./home.nix;

            home-manager.extraSpecialArgs = {
              inherit nixvim;
            };
          }
          ({ lib, ... }: {
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.nixvim.flake = nixvim;
            nix.registry.stylix.flake = stylix;
          })
        ];
      };
    };
  };
 }
