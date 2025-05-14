{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gcc
    kdenlive
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     curl
    # jetbrains.pycharm-professional
    # jre8
    # qemu
    # quickemu
  ];
}
