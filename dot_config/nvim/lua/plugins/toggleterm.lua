local keymaps = require("keymaps")

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local FloatingTerminal = require("toggleterm.terminal").Terminal
      local lazygit = FloatingTerminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
      local lazydocker = FloatingTerminal:new({ cmd = "lazydocker", hidden = true, direction = "float" })
      function _lazygit_toggle()
        lazygit:toggle()
      end
      function _lazydocker_toggle()
        lazydocker:toggle()
      end
      return keymaps.set_togterm_keys()
    end,
  },
}
