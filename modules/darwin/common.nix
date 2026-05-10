# macOS system-level config shared by all Darwin hosts.
{ pkgs, ... }:
{
  # nix-darwin must explicitly enable the shell it manages
  programs.zsh.enable = true;

  # Minimal system packages — prefer home.packages for user tools
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];

  # ── macOS system defaults (replaces manual `defaults write` commands) ──────
  system.defaults = {
    dock = {
      autohide     = true;
      show-recents = false;
      mru-spaces   = false; # don't reorder Spaces by recent use
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar            = true;
      FXPreferredViewStyle   = "Nlsv"; # list view
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat           = 2;
      InitialKeyRepeat    = 15;
    };
    trackpad.Clicking = true; # tap-to-click
  };

  # ── Homebrew — GUI apps and anything not available in nixpkgs ─────────────
  # nix-darwin manages the Brewfile declaratively; `cleanup = "zap"` removes
  # anything not listed here on every `darwin-rebuild switch`.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup    = "zap";
    };
    casks = [
      "firefox"
      "iterm2"
      "raycast"
    ];
    # masApps = { "Xcode" = 497799835; }; # uncomment if you want App Store apps managed
  };

  # Allow TouchID to authorise sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
