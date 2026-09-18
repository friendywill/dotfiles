-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local plugin_keys = {}

-- Git Signs
function plugin_keys.set_git_sign_keys(map, gitsigns)
  return {
    -- visual mode
    map("v", "<leader>ghi", function()
      -- Stage the selected hunk
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      -- Save unstaged changes to a stash
      vim.cmd("Git stash --keep-index")
      -- Commit the staged hunk
      vim.cmd({ cmd = "Git", args = { "commit" } })
      -- Apply the stash to restage the previous changes
      vim.cmd("Git stash pop")
    end, { desc = "commit just selected hunk" }),
    -- normal mode
    map("n", "<leader>hc", "<Cmd> Git commit<CR>", { desc = "[g]it [c]ommit" }),
  }
end

-- lsp keys
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
