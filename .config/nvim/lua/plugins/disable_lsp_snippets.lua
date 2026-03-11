return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = {
      {
        name = "nvim_lsp",
        entry_filter = function(entry, _ctx)
          -- Ignore snippets from lsp
          if entry:get_kind() == 15 then
            return false
          end
          return true
        end,
      },
    }
  end,
}
