-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false
local opt = vim.opt
opt.colorcolumn = "80"
opt.smoothscroll = true
if vim.env.TUIOS_WINDOW_ID then
  local function drop_underline_colors()
    for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
      if hl.sp and not hl.link then
        hl.sp = nil
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end
  drop_underline_colors()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = drop_underline_colors })
end
