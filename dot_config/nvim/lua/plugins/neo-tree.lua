local keymaps = require("keymaps")
-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = keymaps.set_neotree_keys(),
  opts = {
    group_empty_dirs = true,
    filesystem = {
      group_empty_dirs = true,
      window = {
        mappings = keymaps.set_neotree_keys_other(),
      },
    },
  },
}
