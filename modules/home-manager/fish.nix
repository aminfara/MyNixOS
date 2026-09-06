# Fish shell config exclusive to fish itself — aliases, abbreviations,
# functions, keybindings, plugins. Tool installs and other programs' own
# `programs.*` modules live in sibling files (tools.nix, bat.nix, eza.nix,
# zoxide.nix, starship.nix) even where they carry a fish-integration flag,
# since the tool isn't exclusively a fish concern.
#
# Functional (not literal) port of the fish setup at
# https://github.com/aminfara/dotfiles/tree/main/fish/.config/fish — same
# abbreviations/functions/tool integrations, expressed through home-manager's
# declarative fish options instead of stow'd conf.d files. The functions
# themselves are plain .fish files under ./fish/functions (fish's own
# autoload convention: filename == function name), symlinked in via
# xdg.configFile below — not reimplemented as fish syntax embedded in Nix
# strings.
{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

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

    binds."ctrl-alt-h".command = "_help_current_cmd";

    # Fisher-managed upstream (fisher install <repo>); installed
    # declaratively here instead — Nix owns the plugin sources too.
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
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting ""

      # mise — language tooling; auto-switches versions per project. Package
      # lives in tools.nix; this activation hook is fish-specific.
      mise activate fish | source
    '';
  };

  xdg.configFile = {
    "fish/functions/mkcd.fish".source = ./fish/functions/mkcd.fish;
    "fish/functions/up.fish".source = ./fish/functions/up.fish;
    "fish/functions/n.fish".source = ./fish/functions/n.fish;
    "fish/functions/help.fish".source = ./fish/functions/help.fish;
    "fish/functions/backup.fish".source = ./fish/functions/backup.fish;
    "fish/functions/extract.fish".source = ./fish/functions/extract.fish;
    "fish/functions/_help_current_cmd.fish".source = ./fish/functions/_help_current_cmd.fish;
  };
}
