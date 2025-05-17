# nixos/modules/docker.nix
{
  config,
  pkgs,
  lib,
  ... # Добавим многоточие для гибкости
}:

{
  # Включаем Docker
  virtualisation.docker.enable = true;

  # Добавляем пользователя в группу docker для беспарольного доступа
  # Замените 'kirillkom' на ваше имя пользователя, если оно отличается
  #users.users.kirillkom.extraGroups = lib.mkIf (config.users.users ? "kirillkom") [ "docker" ];
  #virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #};

  # Опционально: если вы хотите использовать Docker Compose V2 (рекомендуется)
  # pkgs.docker-compose-v2 будет доступен, но его нужно будет вызывать как `docker compose`
  #environment.systemPackages = [ pkgs.docker-compose-v2 ];
  # Если вы предпочитаете старый `docker-compose` (версия 1.x):
  # environment.systemPackages = [ pkgs.docker-compose ];
} 