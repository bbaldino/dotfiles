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
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
        }
    }
}

require("telescope").load_extension("ui-select")

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "lua", "rust", "typescript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>ff", "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", { silent = true })

map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")

map("n", "<C-R>", ":cexpr system('cd /home/lal/volume/_docker_build; ../.vscode/vsc_build_test.sh build_and_run ' . expand('%:p'))<cr>:copen<cr>");

vim.cmd [[highlight Pmenu ctermbg=gray ctermfg=white]]
vim.cmd [[highlight CocErrorFloat ctermfg=130]]

require("mason").setup()
require("mason-lspconfig").setup()

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set('n', '<leader>j', vim.lsp.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>k', vim.lsp.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 
    tsserver = {
        init_options = {
            preferences = {
                importModuleSpecifierPreference = "project-relative",
            },
        },
        codeActionsOnSave = {
            source = {
                organizeImports = true
            }
        },
    },
    rust_analyzer = {
    }
}
for name, opt in pairs(servers) do
  lspconfig[name].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = opt.init_options
  }
end

-- luasnip setup
local luasnip = require 'luasnip'
require("luasnip.loaders.from_vscode").lazy_load()

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

vim.g.doge_javascript_settings = {
    destructuring_props = 1,
    omit_redundant_param_types = 1,
}

vim.lsp.set_log_level("debug")
