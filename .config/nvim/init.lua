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
   
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader><space>", ":nohlsearch<CR>")

vim.opt.signcolumn = 'yes'

require('plugins')

--- Telescope keymappings
require('telescope').setup {
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

---- CoC mappings
function esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

-- local function check_back_space()
--   local col = vim.fn.col('.') - 1
--   local ret = col <= 0 or vim.fn.getline('.'):sub(col, col):match('%s')
--   return ret
-- end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

_G.tab_completion = function()
    if vim.fn.pumvisible() == 1 then
        return esc "<C-n>"
    elseif check_back_space() then
        return esc "<Tab>"
    else
        return vim.fn["coc#refresh"]()
    end
end

-- Use tab to cycle through completion menu
vim.keymap.set("i", "<Tab>", "v:lua.tab_completion()", {expr = true})

-- Use enter to select coc completion item
vim.keymap.set(
    "i",
    "<CR>",
    "pumvisible() ? '<C-y>' : '<CR>'",
    { expr = true, silent = true }
)

-- Use shift-tab to reverse cycle through completion menu
map("i", "<S-TAB>", [[pumvisible() ? "<C-p>" : "<C-h>"]], { expr = true })


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

vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected")
vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current")
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename")

vim.cmd [[autocmd CursorHold * silent call CocActionAsync('highlight')]]
-- Make the highlight on cursorhold faster
vim.cmd [[set updatetime=1000]]
