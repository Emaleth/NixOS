{
  description = "Emaleth's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
 };

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";

 in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
       
      modules = [
        ./configuration.nix
        ];
      };
      
 };
}
