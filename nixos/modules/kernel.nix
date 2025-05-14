{ pkgs,nixpkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.allowUnfree = true;  
}
