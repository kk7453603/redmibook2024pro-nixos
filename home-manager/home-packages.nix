{ pkgs, ... }:
let
  hiddify-launcher = pkgs.writeShellScriptBin "hiddify-launcher" ''
    #!${pkgs.runtimeShell}
    set -x # Включаем вывод отладочной информации

    # Захватываем переменные из пользовательского окружения
    USER_DISPLAY="''${DISPLAY}"
    USER_WAYLAND_DISPLAY="''${WAYLAND_DISPLAY}"
    USER_XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR}"
    # USER_XAUTHORITY="''${XAUTHORITY}" # XAUTHORITY часто пуст или не нужен в Wayland

    echo "Захваченные переменные:" >&2
    echo "  DISPLAY (пользовательский): $USER_DISPLAY" >&2
    echo "  WAYLAND_DISPLAY (пользовательский): $USER_WAYLAND_DISPLAY" >&2
    echo "  XDG_RUNTIME_DIR (пользовательский): $USER_XDG_RUNTIME_DIR" >&2
    # echo "  XAUTHORITY (пользовательский): $USER_XAUTHORITY" >&2

    if [ -z "$USER_WAYLAND_DISPLAY" ] && [ -z "$USER_DISPLAY" ]; then
      echo "Критическая ошибка: Ни WAYLAND_DISPLAY, ни DISPLAY не установлены в окружении пользователя." >&2
      exit 1
    fi

    HIDDIFY_CMD="/run/current-system/sw/bin/hiddify"

    echo "Попытка запуска $HIDDIFY_CMD от имени root с использованием pkexec." >&2
    echo "Передаваемые переменные в pkexec env:" >&2
    echo "  WAYLAND_DISPLAY=$USER_WAYLAND_DISPLAY" >&2
    echo "  XDG_RUNTIME_DIR=$USER_XDG_RUNTIME_DIR" >&2

    # Запускаем, передавая только Wayland-специфичные переменные
    # pkexec по умолчанию сильно чистит окружение.
    pkexec env \
      WAYLAND_DISPLAY="$USER_WAYLAND_DISPLAY" \
      XDG_RUNTIME_DIR="$USER_XDG_RUNTIME_DIR" \
      "$HIDDIFY_CMD"
    
    exit_code=$?
    echo "pkexec завершился с кодом выхода: $exit_code" >&2
    exit $exit_code
  '';
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically

    # Desktop apps
    anki
    code-cursor
    vscode
    imv
    mpv
    obs-studio
    obsidian
    pavucontrol
    telegram-desktop
    vesktop
    # CLI utils
    bc
    bottom
    brightnessctl
    cliphist
    ffmpeg
    ffmpegthumbnailer
    fzf
    git-graph
    grimblast
    htop
    hyprpicker
    ntfs3g
    mediainfo
    microfetch
    playerctl
    ripgrep
    showmethekey
    silicon
    udisks
    ueberzugpp
    unzip
    w3m
    wget
    wl-clipboard
    wtype
    yt-dlp
    zip

    # Coding stuff
    openjdk23
    nodejs
    python311
    go
    # WM stuff
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xorg.xhost

    # Other
    bemoji
    nix-prefetch-scripts
    lazydocker
    nix-prefetch-github
    
    hiddify-launcher # Добавляем наш скрипт-обертку

    # Hiddify GUI
     # Используем готовый пакет
    (pkgs.makeDesktopItem {
      name = "hiddify-app";
      desktopName = "Hiddify-root";
      comment = "Hiddify Client";
      exec = "hiddify-launcher"; # Используем просто имя команды, т.к. скрипт будет в PATH
      icon = "hiddify"; # Имя иконки, должно быть установлено пакетом hiddify-app
      terminal = false;
      type = "Application";
      categories = [ "Network" ];
    })
  ];
}
