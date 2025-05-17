{ pkgs,nixpkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_6_14;
  nixpkgs.config.allowUnfree = true;  
}
