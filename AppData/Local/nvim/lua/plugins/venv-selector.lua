return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python", --optional
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = true,
  ft = python,
  opts = {
    search = {
      miniforge = {
        command = "fd python$ ~/.local/share/miniforge3/envs/",
      },
      local_venvs = {
        command = "fd python$ ~/.local/share/venv/",
      },
    },
  },
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" },
  },
}
