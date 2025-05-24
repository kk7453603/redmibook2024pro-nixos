{ pkgs, stateVersion, hostname, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/modules
  ];

  environment.systemPackages = [
    pkgs.home-manager
    inputs.hiddify-clash-meta.packages.${pkgs.system}.default
  ];

  networking.hostName = hostname;

  # Systemd сервис для Hiddify (Clash.Meta)
  systemd.services.hiddify-clash-meta = {
    description = "Hiddify Clash Meta Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "root";
      ExecStart = "${inputs.hiddify-clash-meta.packages.${pkgs.system}.default}/bin/clash-meta -d /etc/hiddify-clash-meta";
      Restart = "on-failure";
    };
  };
  
  # Создаем директорию для конфигурации Hiddify, если она нужна
  # и копируем туда пример конфигурации (если он есть в пакете)
  # Это нужно будет адаптировать под реальную структуру Hiddify
  #environment.etc."hiddify-clash-meta/config.yaml" = {
    #source = pkgs.writeText "hiddify-config.yaml" \'\'\'
# Здесь должна быть твоя конфигурация Hiddify в формате YAML
# Например:
# port: 7890
# socks-port: 7891
# allow-lan: true
# mode: rule
# log-level: info
# external-controller: '0.0.0.0:9090'
# proxies:
#  - name: "MyProxy"
#    type: ss
#    server: server_address
#    port: server_port
#    cipher: AEAD_CHACHA20_POLY1305
#    password: "your_password"
#\'\'\';
    #mode = "0644";
  #};
  
  system.stateVersion = stateVersion;
}

