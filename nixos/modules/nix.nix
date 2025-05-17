{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://hyprland.cachix.org" ];
  nix.settings.trusted-substituters = [ "https://hyprland.cachix.org" ];
  nix.settings.trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];

  # Автоматическая сборка мусора
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Как часто запускать (например, daily, weekly, monthly)
    options = "--delete-older-than 30d"; # Удалять "корни" старше 30 дней и связанные с ними пути
  };

  # Опционально: автоматически оптимизировать хранилище Nix после сборки
  nix.autoOptimiseStore = true;
}
