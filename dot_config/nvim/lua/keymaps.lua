-- TODO: Decide on a way to clean this code, where that be through
-- a map, or unpacking of keys.
--
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

-- Toggleterm
function lsp_keys.set_togterm_keys()
  local opts = { buffer = 0 }
  return {
    vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true }),
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts),
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts),
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts),
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts),
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts),
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts),
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts),
    vim.cmd("autocmd! TermOpen term://*toggleterm#*"),
  }
end

-- Debug
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
    { "<F7>", dapui.toggle, desc = "Debug: See last session result." },
    unpack(keys),
  }
end

-- Git Signs
function lsp_keys.set_git_sign_keys(map, gitsigns)
  return {
    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Jump to next git [c]hange" }),

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Jump to previous git [c]hange" }),

    -- Actions
    -- visual mode
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "stage git hunk" }),
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "reset git hunk" }),
    -- normal mode
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" }),
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" }),
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" }),
    map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" }),
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" }),
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" }),
    map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" }),
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" }),
    map("n", "<leader>hD", function()
      gitsigns.diffthis("@")
    end, { desc = "git [D]iff against last commit" }),
    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" }),
    map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" }),
  }
end

return lsp_keys
