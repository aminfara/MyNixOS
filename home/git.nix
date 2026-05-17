{ settings, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = settings.gitName;
      user.email = settings.email;
      pull.rebase = true;
      pull.ff = "only";
      rebase.autoSquash = true;
      merge.autoStash = true;
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true; # remember conflict resolutions
      core.pager = "delta";
    };

    # Global gitignore
    ignores = [
      ".DS_Store"
      "*.swp"
    ];
  };

  # delta: a syntax-highlighting pager for git diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = false;
    };
  };
}
