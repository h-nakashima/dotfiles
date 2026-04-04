function fish_user_key_bindings
    # ^R: peco select history
    bind \cr _peco_select_history

    # ^F: peco select path
    bind \cf _peco_select_path

    # ^G^A: peco select git add
    bind \cg\ca _peco_select_gitadd

    # ^G^B: peco checkout branch
    bind \cg\cb _peco_checkout_branch

    # ^G^L: peco cd ghq
    bind \cg\cl _peco_cd_ghq
end

function _peco_select_history
    history | peco --query (commandline) | read -l selected
    if test -n "$selected"
        commandline $selected
    end
end

function _peco_select_path
    set -l filepath (find . -type f -o -type d | grep -v '/\.' | peco --prompt 'PATH>')
    if test -z "$filepath"
        return
    end

    set -l cmd (commandline)
    if test -z "$cmd"
        if test -d "$filepath"
            commandline "cd $filepath"
        else if test -f "$filepath"
            set -l editor_cmd $EDITOR
            if test -z "$editor_cmd"
                set editor_cmd "nano"
            end
            commandline "$editor_cmd $filepath"
        end
    else
        commandline -i "$filepath"
    end
    commandline -f repaint
end

function _peco_select_gitadd
    set -l SELECTED_FILE_TO_ADD (git status --porcelain | peco | awk -F ' ' '{print $NF}')
    if test -n "$SELECTED_FILE_TO_ADD"
        set -l clean_files (string join " " $SELECTED_FILE_TO_ADD)
        commandline "git add $clean_files"
        commandline -f execute
    end
end

function _peco_checkout_branch
    set -l branch (git branch -a | ruby -e 'bs=readlines.map(&:strip);lb=bs.select{|b|!(/^remotes\/origin/ =~ b)};rb=bs.select{|b|/^remotes\/origin/ =~ b}.select{|b|!b.include?("->") && !lb.include?(b.gsub("remotes/origin/",""))};puts lb.select{|b|!(/^\*/ =~ b)} + rb' | peco --prompt 'git checkout')
    if test -n "$branch"
        set -l clean_branch (echo $branch | sed 's/remotes\/origin\///g')
        commandline "git checkout $clean_branch"
        commandline -f execute
    end
end

function _peco_cd_ghq
    set -l cdto (ghq list -p | peco --prompt 'cd ')
    if test -n "$cdto"
        commandline "cd $cdto"
        commandline -f execute
    end
end
