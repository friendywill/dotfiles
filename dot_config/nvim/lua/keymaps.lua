-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ LSP Keymaps ]] TODO: Add other LSP keymaps here.
local lsp_keys = {}

function lsp_keys.set_dap_keys(_, keys, dap, dapui)
  return {
    -- Basic debugging keymaps, feel free to change to your liking!
    { "<leader>Dc", dap.continue, desc = "Debug: Start/Continue" },
    { "<leader>Dsi", dap.step_into, desc = "Debug: Step Into" },
    { "<leader>Dso", dap.step_over, desc = "Debug: Step Over" },
    { "<leader>Dsu", dap.step_out, desc = "Debug: Step Out" },
    { "<leader>Db", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
    {
      "<leader>DB",
      function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Breakpoint",
    },
    print("test"),
    { "<F7>", dapui.toggle, desc = "Debug: See last session result." },
    unpack(keys),
  }
end

return lsp_keys
