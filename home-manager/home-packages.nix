{ pkgs, ... }: {
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

    # Other
    bemoji
    nix-prefetch-scripts
    lazydocker
    nix-prefetch-github
    # Hiddify GUI (AppImage)
    (let
      # ЗАМЕНИ ЭТИ ЗНАЧЕНИЯ!
      # Перейди на https://github.com/hiddify/hiddify-app/releases
      # Скопируй URL для Hiddify-Linux-x64.AppImage и его SHA256 хэш
      appimageUrl = "https://github.com/hiddify/hiddify-next/releases/download/v2.5.7/Hiddify-Linux-x64.AppImage"; # Например: "https://github.com/hiddify/hiddify-app/releases/download/vX.Y.Z/Hiddify-Linux-x64.AppImage"
      appimageSha256 = "1j5ljy0mgxv70pjkhf6cif5hvq0bm2d2vhal75l1pbdfxklrj6p5"; # Например: "0abcdef1234567890abcdef1234567890abcdef1234567890abcdef123456789"
      appName = "hiddify-gui";
    in pkgs.stdenv.mkDerivation {
      name = appName;
      src = pkgs.fetchurl {
        url = appimageUrl;
        sha256 = appimageSha256;
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/${appName}
        chmod +x $out/bin/${appName}

        # Создаем .desktop файл для меню приложений
        mkdir -p $out/share/applications
        cat > $out/share/applications/${appName}.desktop << EOF
        [Desktop Entry]
        Name=Hiddify
        Comment=Hiddify Proxy Client
        Exec=$out/bin/${appName} %U
        Terminal=false
        Type=Application
        Icon=${ # Попытка найти иконку, если она есть в AppImage, или указать стандартную
                  # Это более сложная часть, для начала можно оставить или использовать стандартную иконку
                  # Например, pkgs.hicolor_icon_theme или если у hiddify есть отдельный пакет с иконками
                  # Для простоты пока можно оставить пустым или указать системную.
                  # Если AppImage содержит иконку, ее можно было бы извлечь, но это усложняет derivation.
                  # Для начала попробуем так, возможно, AppImage сам зарегистрирует иконку.
                  # Или можно будет позже добавить `pkgs.makeWrapper` и указать `xdg-icon-resource`
                  ""
                }
        Categories=Network;Proxy;
        EOF
      '';
      # Обертка для запуска AppImage
      # Вместо прямого запуска, лучше использовать appimage-run, если AppImage не содержит все зависимости
      # Но для начала попробуем так, если не заработает, добавим appimage-run
    })
  ];
}
