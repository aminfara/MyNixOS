# Zsh + shell environment — identical on Linux and macOS.
{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --group-directories-first";
      cat = "bat --paging=never";
      lg = "lazygit";
    };

    initExtra = ''
      # zoxide must be initialised after compinit
      eval "$(zoxide init zsh)"
    '';
  };

  # Starship — cross-shell prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # fzf shell integration (Ctrl-R history, Ctrl-T file, Alt-C cd)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
