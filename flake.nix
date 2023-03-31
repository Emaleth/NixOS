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
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
 };

  outputs = inputs@{ nixpkgs, home-manager, hyprland, ... }: 
  {  
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.users.emaleth = import ./home.nix;
          #homeConfiguration.emaleth = home-manager.lib.homeManagerConfiguration {
          #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
          #  modules = [
          #    hyprland.homeManagerModules.default
          #  ];
          #};
          home-manager.extraSpecialArgs = {
            inherit hyprland;
          };
        }
        hyprland.nixosModules.default
        ];
      };   
    };
#    homeConfigurations."emaleth" = home-manager.lib.homeManagerConfiguration {
#      modules = [
#        hyprland.homeManagerModules.default
#      ];
#    };
  };
}