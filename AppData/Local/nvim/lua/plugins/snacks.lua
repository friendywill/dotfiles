return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      animate = {
        duration = { step = 5, total = 50 }, -- Lower numbers = faster animation (Defaults are step = 10, total = 200)
      },
      animate_repeat = {
        delay = 100,
        duration = { step = 2, total = 20 }, -- Faster when holding down scroll keys
      },
    },
  },
}

