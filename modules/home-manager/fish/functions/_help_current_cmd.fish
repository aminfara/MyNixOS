# Bound to ctrl-alt-h (see ../../fish.nix). Toggles `help <cmd>` on the
# current command line; needs a terminal that forwards Ctrl-Alt-* (Ghostty,
# kitty, Alacritty — not every embedded/IDE terminal does).
function _help_current_cmd
    set -l cmd (commandline | string trim)

    if test -z "$cmd"
        set -l last (history --max=1)
        if string match -qr '^\s*help\s+\S' -- "$last"
            set -l stripped (string replace -r '^\s*help\s+' '' -- "$last")
            commandline -r -- "$stripped"
        end
        return
    end

    if string match -qr '^help\s+\S' -- "$cmd"
        set -l stripped (string replace -r '^help\s+' '' -- "$cmd")
        commandline -r -- "$stripped"
    else
        commandline -r -- "help $cmd"
        commandline -f execute
    end
end
