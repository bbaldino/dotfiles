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
---- CoC mappings
function esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

map("n", "<leader>qf", "<Plug>coc-fix-current")

_G.tab_completion = function()
    if vim.fn.pumvisible() == 1 then
        return esc "<C-n>"
    --else if vim.fn["coc#expandableOrJumpable"]() then
    --    return esc "<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
    elseif check_back_space() then
        return esc "<Tab>"
    else
        return vim.fn["coc#refresh"]()
    end
end

_G.s_tab_completion = function()
    if vim.fn.pumvisible() == 1 then
        return esc "<C-p>"
    else
        return esc "<S-Tab>"
    end
end

vim.keymap.set("i", "<Tab>", "v:lua.tab_completion()", {expr = true})
vim.keymap.set("i", "<S-Tab>", "v:lua.s_tab_completion()", {expr = true})

-- Use enter to select coc completion item
vim.keymap.set(
    "i",
    "<CR>",
    "pumvisible() ? '<C-y>' : '<CR>'",
    { expr = true, silent = true }
)



-- Improve the colors used for some CoC popup windows
vim.cmd [[highlight Pmenu ctermbg=gray ctermfg=white]]
vim.cmd [[highlight CocErrorFloat ctermfg=130]]

_G.show_documentation = function()
  if vim.fn.index({"vim", "help"}, vim.bo.filetype) >= 0 then
    vim.cmd([[execute 'h '.expand('<cword>')]])
  elseif vim.fn["coc#rpc#ready"]() then
    vim.cmd([[call CocActionAsync('doHover')]])
  else
    vim.cmd([[execute '!' . &keywordprg . " " . expand('<cword>')]])
  end
end

vim.keymap.set("n", "K", "v:lua.show_documentation()", { expr = true })

vim.api.nvim_create_augroup("typescript", {clear = true})
vim.api.nvim_create_autocmd("FileType", {
  group = "typescript",
  pattern = "typescript",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
  end,
})

require('coc')
