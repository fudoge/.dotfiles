return {
    'tribela/transparent.nvim',
    event = 'VimEnter',

    config = function()
        require("transparent").setup({
            auto = true,
            extra_groups = {
                -- Basic UI
                "Normal", "NormalNC", "NormalFloat", "FloatBorder",
                "SignColumn", "EndOfBuffer", "LineNr", "CursorLine", "CursorLineNr",
                "WinSeparator", "MsgArea", "StatusLine", "StatusLineNC",

                -- Popup/Menu
                "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",

                -- Telescope
                "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
                "TelescopePromptBorder", "TelescopeResultsNormal", "TelescopeResultsBorder",

                -- Neo-tree
                "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer", "NeoTreeFloatNormal", "NeoTreeFloatBorder",

                -- Alpha
                "AlphaNormal",

                -- Dressing
                "DressingNormal", "DressingBorder",

                -- LSP Saga
                "SagaNormal", "SagaBorder",

                -- nvim-cmp
                "CmpNormal", "CmpBorder",

                -- Barbar / Bufferline
                "BufferLineFill", "BufferLineBackground",
            },
            excludes = {},
        })
    end
}
