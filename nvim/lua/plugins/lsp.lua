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
                "terraformls"
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
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.ts_ls.setup({})
            lspconfig.gopls.setup({})
            lspconfig.bashls.setup({})
            lspconfig.cssls.setup({})
            lspconfig.clangd.setup({
                cmd = { "clangd", "--header-insertion=never", "--query-driver=/usr/bin/g++", "--fallback-style=Google" },
                args = { "--include-directory=/usr/local/include" },
            })
            lspconfig.docker_compose_language_service.setup({})
            lspconfig.graphql.setup({})
            lspconfig.jdtls.setup({})
            lspconfig.biome.setup({})
            lspconfig.ltex.setup({})
            lspconfig.nginx_language_server.setup({})
            lspconfig.sqls.setup({})
            lspconfig.yamlls.setup({})
            lspconfig.pyright.setup({})
            lspconfig.dockerls.setup({})
            lspconfig.terraformls.setup({})

            -- vim.lsp.buf.hover
            -- vim.lsp.buf.definition
            -- vim.lsp.buf.code_action
            keyMapper("K", vim.lsp.buf.hover)
            keyMapper("gd", vim.lsp.buf.definition)
            keyMapper("<leader>ca", vim.lsp.buf.code_action)
        end,
    },
}
