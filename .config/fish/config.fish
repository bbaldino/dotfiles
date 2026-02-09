if status is-interactive
    fish_add_path /home/bbaldino/.cargo/bin
    fish_add_path /home/bbaldino/.local/share/bob/nvim-bin/
    fish_add_path /home/bbaldino/.local/bin
    alias config='/usr/bin/git --git-dir=/home/bbaldino/.cfg/ --work-tree=/home/bbaldino'
    set -g fish_key_bindings fish_vi_key_bindings
    set -gx EDITOR nvim
    set -gx VISUAL nvim
end

# machine-specific overrides
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
