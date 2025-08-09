return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- 안정 버전 사용 권장
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            server = {
                on_attach = function(_, bufnr)
                    -- LSP 기본 키맵 설정 등 여기에
                end,
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
        }
    end
}
