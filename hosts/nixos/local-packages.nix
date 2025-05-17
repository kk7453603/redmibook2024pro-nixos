{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gcc
    kdePackages.kdenlive
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     curl
     #discord
     tlp
     cacert
     #jetbrains.pycharm-professional
    # jre8
    # qemu
    # quickemu
  ];
  environment.variables.SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
}
