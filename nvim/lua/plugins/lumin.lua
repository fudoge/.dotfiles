return {
    -- dir = "~/dev/lumin-nvim",
    "fudoge/lumin.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("lumin")
    end,
}
