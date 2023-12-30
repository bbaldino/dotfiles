return function()
  -- Jump to last position in buffer
  vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  -- This shouldn't be needed with vim.o.clipboard = 'unnamedplus'
  -- vim.keymap.set('v', '<leader>y', '"+y', { desc = "Copy selection to system clipboard" })

  -- Override this from kickstart's default
  vim.o.hlsearch = true
  -- Clear highlight
  vim.keymap.set('n', '<leader>,', ':nohlsearch<CR>', { desc = 'Clear search highlit' })

  -- TODO: conflicts with switching tabs...also doesn't seem to jump the cursor to the right spot
  vim.keymap.set('n', 'gT', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    { desc = '[G]oto definition in new [t]ab' })

  local luasnip = require 'luasnip'
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("UnlinkLuaSnipSnippetOnModeChange", {
      clear = true,
    }),
    pattern = { "s:n", "i:*" },
    desc = "Forget the current snippet when leaving the insert mode",
    callback = function(evt)
      -- If we have n active nodes, n - 1 will still remain after a `unlink_current()` call.
      -- We unlink all of them by wrapping the calls in a loop.
      while true do
        if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
          luasnip.unlink_current()
        else
          break
        end
      end
    end,
  })
end
