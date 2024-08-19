-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- docker
if vim.fn.executable("lazydocker") == 1 then
  vim.keymap.set("n", "<leader>gd", function()
    LazyVim.terminal("lazydocker", { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "Lazydocker" })
end

vim.keymap.set("n", "<leader>gSp", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Go to [P]revious Hunk" })
vim.keymap.set("n", "<leader>gSn", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to [N]ext Hunk" })
vim.keymap.set("n", "<leader>gSv", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "Pre[v]iew Hunk" })
vim.keymap.set("n", "<leader>gSs", require("gitsigns").stage_hunk, { buffer = bufnr, desc = "[S]tage Hunk" })
vim.keymap.set("n", "<leader>gSr", require("gitsigns").reset_hunk, { buffer = bufnr, desc = "[R]eset Hunk" })
vim.keymap.set("n", "<leader>gSS", require("gitsigns").stage_buffer, { buffer = bufnr, desc = "[S]tage Buffer" })
vim.keymap.set("n", "<leader>gSu", require("gitsigns").undo_stage_hunk, { buffer = bufnr, desc = "[U]ndo Stage Hunk" })
vim.keymap.set("n", "<leader>gSR", require("gitsigns").reset_buffer, { buffer = bufnr, desc = "[R]eset Buffer" })
vim.keymap.set("n", "<leader>gSb", require("gitsigns").blame_line, { buffer = bufnr, desc = "[B]lame Line" })
vim.keymap.set(
  "n",
  "<leader>gSB",
  require("gitsigns").toggle_current_line_blame,
  { buffer = bufnr, desc = "Toggle Current Line [B]lame" }
)
vim.keymap.set("n", "<leader>gSd", require("gitsigns").diffthis, { buffer = bufnr, desc = "[D]iff This File" })
vim.keymap.set("n", "<leader>gSD", require("gitsigns").toggle_deleted, { buffer = bufnr, desc = "Toggle [D]eleted" })
