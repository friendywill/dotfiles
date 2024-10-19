local keymaps = require("keymaps")

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
      function _lazygit_toggle()
        lazygit:toggle()
      end
      return keymaps.set_togterm_keys()
    end,
  },
}
