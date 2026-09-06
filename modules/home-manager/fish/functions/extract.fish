function extract --description 'Extract any archive'
    for file in $argv
        if not test -f $file
            echo "extract: '$file' is not a file"
            continue
        end

        switch $file
            case '*.tar.gz' '*.tgz'
                tar xzf $file
            case '*.tar.bz2' '*.tbz2'
                tar xjf $file
            case '*.tar.xz' '*.txz'
                tar xJf $file
            case '*.tar.zst'
                tar --zstd -xf $file
            case '*.tar'
                tar xf $file
            case '*.zip'
                unzip $file
            case '*.gz'
                gunzip $file
            case '*.bz2'
                bunzip2 $file
            case '*.xz'
                xz -d $file
            case '*.zst'
                zstd -d $file
            case '*.7z'
                7z x $file
            case '*'
                echo "extract: '$file' — unknown archive format"
        end
    end
end
