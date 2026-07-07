return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = "Refactor",
  keys = {
    { "<leader>r", mode = { "n", "x" } },
  },
  config = function()
    require("refactoring").setup()
  end,
}
