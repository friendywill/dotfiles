---@class lsp.ClientCapabilities
local local_cap = vim.lsp.protocol.make_client_capabilities()

local util = require 'lspconfig.util'
local_cap.offsetEncoding = { "utf-16" }

-- # https://github.com/Fildo7525/nvim/blob/master/lua/usr/lsp/settings/clangd.lua
