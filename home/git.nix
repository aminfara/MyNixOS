# Git — config shared across all machines.
{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Ali 🚶";
    userEmail = "ali.aminfar@gmail.com";

    # delta: a syntax-highlighting pager for git diffs
    delta = {
      enable = true;
      options = {
        navigate = true; # n/N to jump between diff sections
        line-numbers = true;
        side-by-side = false; # set true if you prefer side-by-side diffs
      };
    };

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      rerere.enabled = true; # remember conflict resolutions
      core.editor = "nvim";
    };

    # Global gitignore
    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv"
      ".envrc"
    ];
  };
}
