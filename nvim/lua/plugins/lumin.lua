return {
    dir = "~/dev/lumin-nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("lumin-blur")
    end,
}
