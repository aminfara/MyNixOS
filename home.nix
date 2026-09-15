{ config, pkgs, ... }:

{
  imports = [ ./zsh.nix ];

  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    nixfmt
    nixd
    claude-code
    ghostty
    stylua
    lua-language-server

    # CLI tools used by the fish config below (replaces brew-installed tools).
    bat
    btop
    eza
    fd
    fzf
    delta
    lazygit
    neovim
    ripgrep
    yazi
  ];

  # Nix knows exactly what's installed, so these are set unconditionally
  # instead of guarding with `command -q` at fish runtime.
  home.sessionVariables = {
    TERM = "xterm-256color";

    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";

    MANROFFOPT = "-c"; # prevent raw escape codes in man pages piped through bat
    BAT_PAGER = "less";
    MANPAGER = "sh -c 'col -bx | bat --style=plain --language=man'";
    PAGER = "bat --paging=always --style=plain";
  };

  # Extra PATH entries (replaces the user-bin portion of the old fish
  # PATH bootstrap; the brew/`/usr/local` portions have no Nix equivalent
  # needed, so they're dropped).
  home.sessionPath = [
    "$HOME/.local/sbin"
    "$HOME/.local/bin"
    "$HOME/sbin"
    "$HOME/bin"
  ];

  # Symlinked out of the store (not copied) so editing the file in the repo
  # takes effect immediately -- no rebuild/switch needed to pick up changes.
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workplace/MyNIXOS/hypr/hyprland.lua";

  programs.fish = {
    enable = true;

    # Trivial one-liner; not worth its own file.
    interactiveShellInit = "set -g fish_greeting ''";

    # Ctrl-Alt-H toggles `help` on the current command line (see
    # fish/functions/help-toggle.fish). Needs a terminal that forwards
    # Ctrl-Alt-* (Ghostty yes, VSCode's terminal no).
    binds."ctrl-alt-h".command = "_help_current_cmd";

    functions = {
      help = {
        body = builtins.readFile ./fish/functions/help.fish;
        description = "Render --help output through bat";
      };
      mkcd = {
        body = builtins.readFile ./fish/functions/mkcd.fish;
        description = "mkdir -p and cd into it";
      };
      _help_current_cmd.body = builtins.readFile ./fish/functions/help-toggle.fish;
    };

    shellAbbrs = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      c = "clear";
      path = "string split : -- $PATH";

      top = "btop -p 0";
      psi = "btop -p 1";

      lg = "lazygit";

      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gap = "git add --patch";
      gb = "git branch";
      gba = "git branch --all";
      gbr = "git branch --remote";
      gbl = "git blame -w";
      gc = "git commit --verbose";
      gcm = "git commit --verbose --message";
      gca = "git commit --verbose --amend";
      gcf = "git config --list";
      gcfg = "git config --list --global";
      gcl = "git clone --recurse-submodules";
      gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcoB = "git checkout -B";
      gcp = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";
      gd = "git diff";
      gds = "git diff --staged";
      gf = "git fetch";
      gfa = "git fetch --all --tags --prune --jobs=10";
      gfo = "git fetch origin";
      gl = "git pull";
      glg = "git log --stat";
      glgg = "git log --graph";
      glo = "git log --oneline --decorate";
      glog = "git log --oneline --decorate --graph";
      gloga = "git log --oneline --decorate --graph --all";
      glol = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'';
      glola = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'';
      glols = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'';
      gm = "git merge";
      gma = "git merge --abort";
      gmc = "git merge --continue";
      gmff = "git merge --ff-only";
      gms = "git merge --squash";
      gp = "git push";
      gpf = "git push --force";
      glrv = "git pull --rebase -v";
      gr = "git remote";
      gra = "git remote add";
      grh = "git reset";
      grhh = "git reset --hard";
      grm = "git rm";
      grmc = "git rm --cached";
      grv = "git remote --verbose";
      gsh = "git show";
      gst = "git status";
      gsb = "git status --short --branch";
      gsta = "git stash push";
      gstaa = "git stash apply";
      gstall = "git stash --all";
      gstc = "git stash clear";
      gstd = "git stash drop";
      gstl = "git stash list";
      gstp = "git stash pop";
      gsts = "git stash show --patch";
      gwipe = "git reset --hard && git clean --force -dfx";
    };

    # bat/eza aliases (not abbrs) so shell history records the real command
    # (`cat`, `ls`, `cd`) instead of the expansion.
    shellAliases = {
      cat = "bat --paging=never --style=plain";

      ls = "eza";
      lsi = "eza --group-directories-first --icons";
      ll = "eza --group-directories-first --icons -l";
      la = "eza --group-directories-first --icons -al";
      l = "eza --group-directories-first --icons -aal";

      cd = "z";
      cdi = "zi";
    };

    # Replaces fisher + fish_plugins. Plugin sources come from nixpkgs so
    # they're pinned by the flake lock instead of a mutable `fisher update`.
    # (jorgebucaran/fisher itself is dropped -- a plugin manager isn't
    # needed when Nix is already managing plugin installation.)
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };

  programs.starship = {
    enable = false;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # `zoxide init fish`; cd/cdi aliases above wire it in.
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;

    globalConfig = {
      tools = {
        python = "3.14";
        node = "lts";
      };

      # Prefer precompiled builds over compiling from source -- NixOS has no
      # C toolchain on PATH by default. Needs programs.nix-ld.enable (in
      # configuration.nix) so the precompiled binaries can actually run.
      settings = {
        python.compile = false;
        node.compile = false;
      };
    };
  };

  programs.home-manager.enable = true;
}
