function help --description 'Render --help output through bat'
    $argv --help 2>&1 | bat --language=help --style=plain --paging=never
end
