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

  outputs = {nixpkgs, home-manager, hyprland, ...}: {  
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.users.emaleth = import ./home.nix;
          home-manager.extraSpecialArgs = {
            inherit hyprland;
          };
        }
        hyprland.nixosModules.default
        ];
      };   
    };
  };
}