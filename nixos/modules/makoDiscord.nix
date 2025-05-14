{ config, lib, pkgs, ... }: {
  # You will need to add a call for the daemon to actually function.
  # This is usually done within the configuration of your respective WM.
  # See the official wiki/documentation for your WM for more info.
  environment.systemPackages = with pkgs; [
    mako
  ];
}