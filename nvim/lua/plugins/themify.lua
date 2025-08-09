return {
    'lmantw/themify.nvim',

    lazy = false,
    priority = 999,

    config = function()
        require('themify').setup({
            'folke/tokyonight.nvim',
            'projekt0n/github-nvim-theme',
            'ellisonleao/gruvbox.nvim',
            'catppuccin/nvim',
            'lunacookies/vim-colors-xcode',
            'sainnhe/everforest',
            'nordtheme/vim',
            'marko-cerovac/material.nvim',
            'Mofiqul/dracula.nvim',
            'rebelot/kanagawa.nvim',
            'default'
        })
    end
}
