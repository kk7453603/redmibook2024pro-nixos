{ pkgs, ... }: # Убедимся, что pkgs здесь есть

let
  # Скрипт для циклического переключения режимов TLP (AC/Battery)
  toggleTlpModeScript = pkgs.writeShellScriptBin "toggle_tlp_mode" ''
    #!${pkgs.bash}/bin/bash
    set -e

    # Получаем текущий источник питания от tlp-stat
    # Вывод tlp-stat -s содержит строку типа "Mode próximas = AC" или "Mode próximas = BAT"
    # или "System          = Primarely AC" / "System          = Primarely Battery"
    # Более надежно будет смотреть на /sys/class/power_supply/AC/online или аналогичный.
    # Но для простоты и использования tlp, попробуем так:
    current_mode_line=$(LANG=C ${pkgs.tlp}/bin/tlp-stat -s | grep -E "Mode|System[[:space:]]*=" )
    new_mode_text=""
    current_actual_mode="unknown"

    if echo "$current_mode_line" | grep -q -i "AC"; then
      # Текущий режим AC, переключаем на BAT
      sudo ${pkgs.tlp}/bin/tlp bat
      new_mode_text="Switched to Battery mode (powersave)"
      current_actual_mode="BAT"
    elif echo "$current_mode_line" | grep -q -i "BATTERY"; then
      # Текущий режим BAT, переключаем на AC
      sudo ${pkgs.tlp}/bin/tlp ac
      new_mode_text="Switched to AC mode (performance)"
      current_actual_mode="AC"
    else
      # Не удалось определить, попробуем установить AC по умолчанию
      sudo ${pkgs.tlp}/bin/tlp ac
      new_mode_text="Could not determine mode, switched to AC mode (performance)"
      current_actual_mode="AC"
    fi

    ${pkgs.libnotify}/bin/notify-send -i battery "TLP Mode Changed" "$new_mode_text"

    # Waybar может не обновить значок батареи/режим автоматически.
    # Эта команда заставит Waybar обновить все модули, но это может быть излишним.
    # pkill -SIGRTMIN+8 waybar 
    # Вместо этого, можно попробовать обновить конкретный модуль, если Waybar это поддерживает,
    # или просто положиться на то, что tlp изменит состояние системы, и Waybar это подхватит.
  '';
in
{
  # Добавляем скрипт и libnotify в доступные пакеты
  home.packages = [ toggleTlpModeScript pkgs.tlp pkgs.libnotify ];

  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "battery" "clock" "tray"];
        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "magic" = "";
          };

          persistent-workspaces = {
            "*" = 9;
          };
        };

        "hyprland/language" = {
          format-en = "🇺🇸";
          format-ru = "🇷🇺";
          format-he = "🇮🇱";
          min-length = 5;
          tooltip = false;
        };

        "custom/weather" = {
          format = " {} ";
          exec = "curl -s 'wttr.in/Tashkent?format=%c%t'";
          interval = 300;
          class = "weather";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          on-click = "pavucontrol";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}% @ {status}";
          format-charging = " {capacity}% @ {status}";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
          on-click = "${toggleTlpModeScript}/bin/toggle_tlp_mode";
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
          format-alt = "{:%A, %B %d at %R}";
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };
      };
    };
  };
}
