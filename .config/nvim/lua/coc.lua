-- Coc-related config

local map = require('utils').map

local esc = function(cmd)
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

_G.tab_completion = function()
    if vim.fn.pumvisible() == 1 then
        return esc("<C-n>")
    elseif check_back_space() then
        return esc("<Tab>")
    else
        return vim.fn["coc#refresh"]()
    end
end

-- Use tab to cycle through completion menu
vim.keymap.set("i", "<Tab>", "v:lua.tab_completion()", {expr = true})
-- Use shift-tab to reverse cycle through completion menu
map("i", "<S-TAB>", [[pumvisible() ? "<C-p>" : "<C-h>"]], { expr = true })

-- Use enter to select coc completion item
vim.keymap.set(
    "i",
    "<CR>",
    "pumvisible() ? '<C-y>' : '<CR>'",
    { expr = true, silent = true }
)

-- Use ctrl-h to toggle between header and source file
vim.keymap.set("n", "<C-h>", ":CocCommand clangd.switchSourceHeader<cr>", { silent = true })

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
