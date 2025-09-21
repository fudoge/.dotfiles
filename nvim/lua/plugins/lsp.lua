local keyMapper = require("utils.keyMapper").mapKey

return {
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "ts_ls",
                "gopls",
                "bashls",
                "cssls",
                "clangd",
                "docker_compose_language_service",
                "graphql",
                "jdtls",
                "biome",
                "ltex",
                "nginx_language_server",
                "sqls",
                "yamlls",
                "pyright",
                "dockerls",
                "terraformls",
                "helm_ls",
                "gh_actions_ls"
            },
            automatic_installation = true,
        },
        config = function()
            require("mason").setup({})
            require("mason-lspconfig").setup({})
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("lua_ls", {})
            vim.lsp.config("ts_ls", {})
            vim.lsp.config("gopls", {})
            vim.lsp.config("bashls", {})
            vim.lsp.config("cssls", {})
            vim.lsp.config("clangd", {
                cmd = { "clangd", "--header-insertion=never", "--query-driver=/usr/bin/g++", "--fallback-style=Google", "--include-directory=/usr/local/include" },
            })
            vim.lsp.config("docker_compose_language_service", {})
            vim.lsp.config("graphql", {})
            vim.lsp.config("jdtls", {})
            vim.lsp.config("biome", {})
            vim.lsp.config("ltex", {})
            vim.lsp.config("nginx_language_server", {})
            vim.lsp.config("sqls", {})
            vim.lsp.config("yamlls", {})
            vim.lsp.config("pyright", {})
            vim.lsp.config("dockerls", {})
            vim.lsp.config("terraformls", {})
            vim.lsp.config("helm_ls", {})
            vim.lsp.config("gh_actions_ls", {})

            vim.lsp.enable({
                "lua_ls",
                "ts_ls",
                "gopls",
                "bashls",
                "cssls",
                "clangd",
                "docker_compose_language_service",
                "graphql",
                "jdtls",
                "biome",
                "ltex",
                "nginx_language_server",
                "sqls",
                "yamlls",
                "pyright",
                "dockerls",
                "terraformls",
                "helm_ls",
                "gh_actions_ls"
            })

            -- vim.lsp.buf.hover
            -- vim.lsp.buf.definition
            -- vim.lsp.buf.code_action
            keyMapper("K", vim.lsp.buf.hover)
            keyMapper("gd", vim.lsp.buf.definition)
            keyMapper("<leader>ca", vim.lsp.buf.code_action)
        end,
    },
}
