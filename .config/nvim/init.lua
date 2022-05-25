--------------- Spaces & Tabs ---------------
vim.opt.tabstop = 4                 -- number of visual spaces per tab
vim.opt.softtabstop = 4             -- number of spaces in tab when editing
vim.opt.expandtab = true            -- tabs are spaces
vim.opt.shiftwidth = 4              -- number of space chars inserted for indent
vim.opt.bs = "indent,eol,start"     -- allow backspacing over everything in insert mode

--------------- UI Config ---------------
vim.opt.cursorline = true           -- Highlight current line

vim.g.mapleader=","

vim.opt.ignorecase = true
vim.opt.smartcase = true            -- only do a case-sensitive search if the search term has upper case
vim.opt.incsearch = true            -- incremental search
vim.opt.hlsearch = true             -- highlight matches

vim.g.noswapfile = true

local map = require('utils').map

vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>")

vim.opt.signcolumn = 'yes'

require('plugins')

require'nvim-lastplace'.setup {
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase"},
    lastplace_open_folds = true
}

--- Telescope keymappings
require('telescope').setup {
    defaults = {
        path_display = { "smart" },
        mappings = {
            i = {
              ["<C-Down>"] = require('telescope.actions').cycle_history_next,
              ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
        },

    },
    extensions = {
        frecency = {
            default_workspace = "CWD",
            show_scores = true
        }
    }
}
--map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>ff", "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", { silent = true })

map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")

map("n", "<C-R>", ":cexpr system('cd /home/lal/volume/_docker_build; ../.vscode/vsc_build_test.sh build_and_run ' . expand('%:p'))<cr>:copen<cr>");

vim.opt.makeprg="ninja -C /home/lal/volume/_docker_build -j 12"

require('coc')
