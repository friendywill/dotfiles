return { -- Autoformat
  "stevearc/conform.nvim",
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "autopep8" },
      html = { "prettierd" },
      yaml = { "yamlfmt" },
      kotlin = { "ktfmt", "ktlint" },
      json = { "jq" },
      markdown = { "markdown-toc", "markdownlint-cli2" },
      _ = { "trim_whitespace" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
      isort = {
        command = "isort",
        args = {
          "-",
        },
      },
    },
  },
}
