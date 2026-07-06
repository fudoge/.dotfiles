return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",

  keys = {
    {
      "<A-,>",
      "<cmd>BufferLineCyclePrev<CR>",
      mode = "n",
      desc = "Prev buffer",
    },
    {
      "<A-.>",
      "<cmd>BufferLineCycleNext<CR>",
      mode = "n",
      desc = "Next buffer",
    },
    {
      "<A-c>",
      "<cmd>bdelete<CR>",
      mode = "n",
      desc = "Close buffer",
    },

    {
      "<leader>bmn",
      "<cmd>BufferLineMoveNext<CR>",
      mode = "n",
      desc = "Move next buffer",
    },
    {
      "<leader>bmp",
      "<cmd>BufferLineMovePrev<CR>",
      mode = "n",
      desc = "Move previous buffer",
    },
    {
      "<leader>bc",
      "<cmd>BufferLinePick<CR>",
      mode = "n",
      desc = "Pick buffer",
    },
    {
      "<leader>bsd",
      "<cmd>BufferLineSortByDirectory<CR>",
      mode = "n",
      desc = "Sort buffers by directory",
    },
    {
      "<leader>bse",
      "<cmd>BufferLineSortByExtension<CR>",
      mode = "n",
      desc = "Sort buffers by extension",
    },
    {
      "<leader>bsi",
      "<cmd>BufferLineSortById<CR>",
      mode = "n",
      desc = "Sort buffers by ID",
    },
  },

  config = function()
    vim.opt.cursorline = true

    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
      },

      highlights = require("lumin.integrations.bufferline")(),
    })
  end,
}
