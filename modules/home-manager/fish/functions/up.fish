function up --description 'Go N directories up (default 1)'
    set -l n 1
    if string match -qr '^\d+$' -- $argv[1]
        set n $argv[1]
    end
    cd (string repeat -n $n ../)
end
