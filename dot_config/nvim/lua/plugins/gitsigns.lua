-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

local keymaps = require("keymaps")

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = keymaps.set_git_sign_keys(),
  },
}
