-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- If the windows clipboard is available, also copy the yanked text
local function copy_to_clipboard()
  -- Get the yanked text from the unnamed register
  local yanked_text = vim.fn.getreg('"')

  -- Check if clip.exe exists (only for Windows)
  local clip_exists = vim.fn.executable("clip.exe") == 1

  if clip_exists then
    -- If clip.exe exists, copy the yanked text to the clipboard
    local handle = io.popen("clip.exe", "w")
    handle:write(yanked_text)
    handle:close()
  end
end

-- Create an autocommand that triggers when text is yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = copy_to_clipboard,
})
-- [[ Plugin Autocommands ]]

local autocmds = {}

function autocmds.lint_autocmds(lint_augroup, lint)
  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end
end

function autocmds.lsp_autocmds(event, client)
  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
      end,
    })
  end
end

return autocmds
