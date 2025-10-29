-- Root Markers
local roots = {
    lua_ls = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    ts_ls = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    gopls = { "go.work", "go.mod", ".git" },
    pyright = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
    yamlls = { ".git" },
    terraformls = { ".terraform", ".git" },
    dockerls = { "Dockerfile", "Containerfile", ".git" },
    cssls = { "package.json", ".git" },
    bashls = { ".git" },
    graphql = { ".git" },
    sqls = { ".config.yml", ".git" },
    clangd = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
    docker_compose_language_service = { "docker-compose.yaml", "docker-compose.yml", "compose.yml", "compose.yaml", ".git" },
    ltex = { ".git" },
    nginx_language_server = { "nginx.conf", ".git" },
    jdtls = { ".git", "pom.xml", "build.gradle", "build.gradle.kts" },
    biome = { "biome.json", "biome.jsonc", "package.json", ".git" },
    helm_ls = { "Chart.yaml", ".git" },
    gh_actions_ls = { ".github/workflows", ".git" },
    rust_analyzer = { "Cargo.toml", ".git" }
}

local servers = {
    "lua_ls", "ts_ls", "gopls", "bashls", "cssls", "clangd",
    "docker_compose_language_service", "graphql", "jdtls", "biome", "ltex",
    "nginx_language_server", "sqls", "yamlls", "pyright", "dockerls",
    "terraformls", "helm_ls", "gh_actions_ls", "rust_analyzer"
}

return {
    -- Mason is responsible for installing LSPs.
    {
        "williamboman/mason.nvim",
        opts = {
            PATH = "prepend",
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        },
        config = function(_, opts) require("mason").setup(opts) end,
    },

    -- lspconfig for catalog only.
    { "neovim/nvim-lspconfig" },

    -- Native LSPs
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- global config
            vim.lsp.config("*", {
                root_markers = { ".git" },
            })

            for name, markers in pairs(roots) do
                vim.lsp.config(name, {
                    root_markers = markers,
                })
            end

            -- overwirte config for something special(e.g. clang)
            vim.lsp.config("clangd", {
                root_markers = roots.clangd,
                cmd = { "clangd", "--header-insertion=never", "--query-driver=/usr/bin/g++", "--fallback-style=Google" },
            })

            vim.lsp.config("rust_analyzer", {
                root_markers = roots.rust_analyzer,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        check = {
                            command = "clippy",
                        },
                        inlayHints = {
                            enable = true,
                            locationLinks = false,
                        },
                        diagnostics = {
                            enable = true,
                        },
                    },
                },
            })

            vim.lsp.config("gopls", {
                root_markers = roots.gopls,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            nilness = true,
                            shadow = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            vim.lsp.config("pyright", {
                root_markers = roots.pyright,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic", -- strict로 바꾸면 더 엄격하게 체크
                            autoImportCompletions = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                root_markers = roots.ts_ls,
                settings = {
                    typescript = {
                        preferences = {
                            importModuleSpecifier = "relative",
                        },
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayVariableTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayVariableTypeHints = true,
                        },
                    },
                },
            })

            vim.lsp.config("lua_ls", {
                root_markers = roots.lua_ls,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })

            -- auto-enable
            vim.lsp.enable(servers)

            -- keymappings
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local buf = args.buf
                    local function bufmap(lhs, rhs)
                        vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true })
                    end
                    bufmap("gd", vim.lsp.buf.definition)
                    bufmap("<leader>ca", vim.lsp.buf.code_action)
                end,
            })
        end,
    },
}
