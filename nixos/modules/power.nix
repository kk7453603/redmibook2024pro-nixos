{ config, pkgs, lib, ... }:

{
  # Общее управление питанием системой
  powerManagement.enable = true;

  # Демон для управления температурным режимом процессора
  services.thermald.enable = true;

  # Расширенное управление питанием для ноутбуков
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance"; # было "производительность"
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";   # было "энергосбереж."

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance"; # было "производительность"
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";        # было "мощность"

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      # Пороги заряда для сохранения здоровья батареи (пример для BAT0)
      # Убедитесь, что BAT0 - это имя вашей основной батареи (можно проверить через `tlp-stat -b`)
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 95;

      # Если у вас есть вторая батарея BAT1, можно настроить и для нее:
      # START_CHARGE_THRESH_BAT1 = 40;
      # STOP_CHARGE_THRESH_BAT1 = 80;

      # Некоторые другие полезные настройки (можно раскомментировать и настроить при необходимости):
      # PCIE_ASPM_ON_AC = "performance";
      # PCIE_ASPM_ON_BAT = "powersave";

      # USB_AUTOSUSPEND = 1; # Включить автоподвешивание USB
      # USB_BLACKLIST = ""; # Список ID устройств USB, для которых автоподвешивание отключено

      # WIFI_PWR_ON_AC = "on";
      # WIFI_PWR_ON_BAT = "off"; # 'on' для включенного Wi-Fi power saving, 'off' для выключенного

      # WOL_DISABLE = "Y"; # Отключить Wake-on-LAN
    };
  };

  # Настройка sudo для tlp (позволяет пользователю kirillkom переключать режимы)
  # Убедитесь, что tlp установлен и доступен по этому пути
  # services.tlp.enable = true должен установить tlp в системный PATH, но для sudo лучше указать полный путь.
  # Мы можем получить путь к tlp через pkgs.tlp, но это значение будет доступно после оценки nixpkgs.
  # Для простоты, предполагаем, что tlp будет в /run/current-system/sw/bin/tlp
  # Более надежный способ - использовать `config.programs.sudo.extraConfig` и функцию, которая найдет путь.
  # Пока что оставим это для ручной проверки пути к tlp после первой сборки.

  # Более декларативный способ указания команд для sudo:
  security.sudo.extraRules = [
    {
      users = [ "kirillkom" ]; # Замените на вашего пользователя, если отличается
      commands = [
        { command = "${pkgs.tlp}/bin/tlp ac"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.tlp}/bin/tlp bat"; options = [ "NOPASSWD" ]; }
        # Если нужны другие команды tlp без пароля:
        # { command = "${pkgs.tlp}/bin/tlp usb"; options = [ "NOPASSWD" ]; }
        # { command = "${pkgs.tlp}/bin/tlp setcharge"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # Убедимся, что пакет tlp доступен для использования в sudo.
  # Это также должно быть сделано автоматически при services.tlp.enable = true.
  # environment.systemPackages = [ pkgs.tlp ]; # Обычно не требуется, если сервис включен.
} 