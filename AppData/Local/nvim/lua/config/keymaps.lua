-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local plugin_keys = {}

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
    map("n", "<leader>hc", "<Cmd> Git commit<CR>", { desc = "git [c]ommit" }),
    map("n", "<leader>hm", "<Cmd> terminal chezmoi apply<CR>", { desc = "C[h]ez[m]oi apply" }),
    map("n", "<leader>hD", function()
      gitsigns.diffthis("@")
    end, { desc = "git [D]iff against last commit" }),
    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" }),
    map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" }),
  }
end

function plugin_keys.lsp_keys(map, client, event)
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
    end, "[T]oggle Inlay [H]ints")
  end
  -- Toggle Diagnostics
  map("<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = event.buf }))
  end, "[T]oggle [D]iagnostics")
  local warnings_hidden = false
  map("<leader>tw", function()
    warnings_hidden = not warnings_hidden
    if warnings_hidden then
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        signs = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        underline = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        jump = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
      })
      vim.notify("Warnings hidden", vim.log.levels.INFO)
    else
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
          severity = { min = vim.diagnostic.severity.HINT },
        },
        signs = {
          severity = { min = vim.diagnostic.severity.HINT },
        },
        underline = {
          severity = { min = vim.diagnostic.severity.HINT },
        },
        jump = {
          severity = { min = vim.diagnostic.severity.HINT },
        },
      })
      vim.notify("Warnings shown", vim.log.levels.INFO)
    end
  end, "[T]oggle [W]arnings")
end

return plugin_keys
