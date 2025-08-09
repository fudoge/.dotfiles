return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "terraform", "hcl", "lua", "go", "java", "c", "go", "cpp", "javascript", "typescript", "html", "dart", "css", "gitignore", "gomod", "gosum", "http", "json", "latex", "nginx", "python", "sql", "swift", "yaml", "dockerfile" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })

        require("nvim-ts-autotag").setup()
    end
}
