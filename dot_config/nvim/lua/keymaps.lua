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

-- vim.keymap.set("v", ">", "<Cmd>norm gv<CR>")

-- docker
-- vim.keymap.set("n", "<leader>do", "<Cmd>term lazydocker", { desc = "Lazydocker" })

-- [[ Plugin Keymaps ]] TODO: Add other plugin keymaps here.
local plugin_keys = {}

function plugin_keys.set_neotree_keys()
  return {
    { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    { "<leader>e", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
  }
end

function plugin_keys.set_neotree_keys_other()
  return {
    ["<leader>e"] = "close_window",
    ["\\"] = "close_window",
  }
end

function plugin_keys.set_which_keys()
  return {
    { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
    { "<leader>d", group = "[D]ocument" },
    { "<leader>l", group = "[L]azy" },
    { "<leader>r", group = "[R]ename" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>w", group = "[W]orkspace" },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
  }
end

-- autoformat
function plugin_keys.set_af_keys()
  return {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  }
end

-- Toggleterm
function plugin_keys.set_togterm_keys()
  return {
    -- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true }),
    vim.api.nvim_set_keymap("n", "<leader>do", "<cmd>lua _lazydocker_toggle()<CR>", { noremap = true, silent = true }),
    vim.api.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], {}),
    vim.api.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], {}),
    vim.api.nvim_set_keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], {}),
    vim.api.nvim_set_keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], {}),
    vim.api.nvim_set_keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], {}),
    vim.api.nvim_set_keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], {}),
    vim.api.nvim_set_keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], {}),
    vim.cmd("autocmd! TermOpen term://*toggleterm#*"),
  }
end

-- Debug
function plugin_keys.set_dap_keys(_, keys, dap, dapui)
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
function plugin_keys.set_git_sign_keys(map, gitsigns)
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
    map("v", "<leader>hij", function()
      -- Stage the selected hunk
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      -- Save unstaged changes to a stash
      vim.cmd("Git stash --keep-index")
      -- Commit the staged hunk
      vim.cmd({ cmd = "Git", args = { "commit" } })
      -- Apply the stash to restage the previous changes
      vim.cmd("Git stash pop")
    end, { desc = "commit just selected hunk" }),
    map("v", "<leader>hic", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      vim.cmd({ cmd = "Git", args = { "commit" } })
    end, { desc = "commit selected hunk" }),
    -- normal mode
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" }),
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" }),
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" }),
    map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" }),
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" }),
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" }),
    map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" }),
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" }),
    map("n", "<leader>hm", vim.fn.system("chezmoi apply"), { desc = "C[h]ez[m]oi apply" }),
    map("n", "<leader>hD", function()
      gitsigns.diffthis("@")
    end, { desc = "git [D]iff against last commit" }),
    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" }),
    map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" }),
  }
end

-- [[ LSP Keymaps ]]

function plugin_keys.lsp_keys(map, client, event)
  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

  -- Find references for the word under your cursor.
  map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map("<leader>gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map("<leader>gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype")

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
    end, "[T]oggle Inlay [H]ints")
  end
end

return plugin_keys
