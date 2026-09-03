return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true, -- Enable the sticky headers feature globally
      max_lines = 5, -- Max number of lines the sticky context can grow to
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
      trim_scope = "outer", -- Discard outer lines if max_lines is exceeded
      mode = "cursor", -- Determine context based on cursor position
      -- Ensure yaml is not explicitly disabled inside this table if present
    },
  },
}
