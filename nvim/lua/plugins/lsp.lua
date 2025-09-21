local keyMapper = require("utils.keyMapper").mapKey

local function root(patterns, fname)
    return vim.fs.root(fname or 0, patterns)
end

local roots = {
    lua_ls = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", "selene.toml", "seleme.yml", ".git" },
    ts_ls = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    gopls = { "go.work", "go.mod", ".git" },
    pyright = { "pyproject.toml", "setup.py", "setup.cfg", "requrements.txt", "Pipfile", "pyrightconfig.json", ".git" },
    yamlls = { ".git" },
    terraformls = { ".terraform", ".git" },
    dockerls = { "Dockerfile", ".git" },
    cssls = { "package.json", ".git" },
    bashls = { ".git" },
    graphql = { ".git" },
    sqls = { ".config.yml", ".git" },
    clangd = { ".clangd", "compile_commands.json", "compile_flags.json", ".git" },
    docker_compose_language_service = { "docker-compose.yaml", "docker-compose.yml", "compose.yml", "compose.yaml", ".git" },
    ltex = { ".git" },
    nginx_language_server = { "nginx.conf", ".git" },
    jdtls = { ".git", "pom.xml", "build.gradle", "build.gradle.kts" },
    biome = { "biome.json", "biome.jsonc", "package.json", ".git" },
    helm_ls = { "Chart.yaml", ".git" },
    gh_actions_ls = { ".git" }
}

local function rd(name)
    return function(fname)
        return root(roots[name] or { ".git" }, fname)
    end
end

local lsp_list = {
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

}

return {
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = lsp_list, automatic_installation = true,
        },
        config = function()
            require("mason").setup({})
            require("mason-lspconfig").setup({})
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("*", { single_file_support = false })
            vim.lsp.config("lua_ls", { root_dir = rd("lua_ls") })
            vim.lsp.config("ts_ls", { root_dir = rd("ts_ls") })
            vim.lsp.config("gopls", { root_dir = rd("gopls") })
            vim.lsp.config("bashls", { root_dir = rd("bashls") })
            vim.lsp.config("cssls", { root_dir = rd("cssls") })
            vim.lsp.config("clangd", { root_dir = rd("cssls") },
                { cmd = { "clangd", "--header-insertion=never", "--query-driver=/usr/bin/g++", "--fallback-style=Google" } })
            vim.lsp.config("docker_compose_language_service", { root_dir = rd("docker_compose_language_service") })
            vim.lsp.config("graphql", { root_dir = rd("graphql") })
            vim.lsp.config("jdtls", { root_dir = rd("jdtls") })
            vim.lsp.config("biome", { root_dir = rd("biome") })
            vim.lsp.config("ltex", { root_dir = rd("ltex") })
            vim.lsp.config("nginx_language_server", { root_dir = rd("nginx_language_server") })
            vim.lsp.config("sqls", { root_dir = rd("sqls") })
            vim.lsp.config("yamlls", { root_dir = rd("yamlls") })
            vim.lsp.config("pyright", { root_dir = rd("pyright") })
            vim.lsp.config("dockerls", { root_dir = rd("dockerls") })
            vim.lsp.config("terraformls", { root_dir = rd("terraformls") })
            vim.lsp.config("helm_ls", { root_dir = rd("helm_ls") })
            vim.lsp.config("gh_actions_ls", { root_dir = rd("gh_actions_ls") })

            local function enable_for_buf(names)
                local bufnr = 0
                local need = {}
                for _, name in ipairs(names) do
                    if #vim.lsp.get_clients({ name = name, bufnr = bufnr }) == 0 then
                        table.insert(need, name)
                    end
                end
                if #need > 0 then vim.lsp.enable(need) end
            end

            enable_for_buf(lsp_list)
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                callback = function() enable_for_buf(lsp_list) end
            })

            -- vim.lsp.buf.definition
            -- vim.lsp.buf.code_action
            keyMapper("gd", vim.lsp.buf.definition())
            keyMapper("<leader>ca", vim.lsp.buf.code_action)
        end,
    },
}
