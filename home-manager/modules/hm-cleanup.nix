# home-manager/modules/hm-cleanup.nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  systemd.user.services."home-manager-cleanup" = {
    Unit = {
      Description = "Clean up old Home Manager generations";
    };
    Service = {
      Type = "oneshot";
      # Используем home-manager из пути пользователя, который должен быть настроен Home Manager'ом
      # Удаляем поколения старше 14 дней (т.е. оставляет те, что новее 14 дней назад)
      # Формат для expire-generations: <период> (например, 7d, 2w, 1m)
      # Эта команда удалит все поколения, кроме тех, что были созданы за последние 14 дней.
      ExecStart = "${pkgs.home-manager}/bin/home-manager expire-generations -m \"14 days ago\"";
    };
  };

  systemd.user.timers."home-manager-cleanup" = {
    Unit = {
      Description = "Run Home Manager cleanup job weekly";
    };
    Timer = {
      OnCalendar = "weekly"; # Запускать еженедельно
      Persistent = true;   # Запустить при следующей загрузке, если пропущено
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
} 