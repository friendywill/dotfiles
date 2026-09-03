return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")
    local mymappings = {
      ["<CR>"] = cmp.config.disable,
      ["<Tab>"] = cmp.config.disable,
    }
    opts.mapping = vim.tbl_deep_extend("force", opts.mapping, mymappings)
    cmp.setup(opts)
  end,
}
