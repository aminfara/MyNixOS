function n --wraps nvim --description 'Open nvim (. if no args)'
    if test (count $argv) -eq 0
        nvim .
    else
        nvim $argv
    end
end
