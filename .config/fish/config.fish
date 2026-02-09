if status is-interactive
    fish_add_path /home/bbaldino/.cargo/bin
    fish_add_path /home/bbaldino/.local/share/bob/nvim-bin/
    alias config='/usr/bin/git --git-dir=/home/bbaldino/.cfg/ --work-tree=/home/bbaldino'
    export EDITOR=nvim
end
export PATH="$HOME/.local/bin:$PATH"
