{ config, pkgs, ... }:

{
  home.file."kitty.conf".source = config.lib.file.mkOutOfStoreSymlink ./Repositories/NixOS/dots/kitty/kitty.conf;
}
