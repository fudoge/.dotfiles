return {
    'goolord/alpha-nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- get current datetime
        local datetime = os.date("%a %b %d %H:%M")

        -- set left padding
        local offset = "      "

        -- set header
        dashboard.section.header.val = {
            offset .. "NEOVIM  ",
            offset .. datetime .. "",
            offset .. "    +                         +                      _.._                    ",
            offset .. "          +                                        .' .-'`             +     ",
            offset .. "+                                                 /  /     +                 ",
            offset .. "                       +                          |  |                       ",
            offset .. "                                              +   \\  \\                       ",
            offset .. "     +                               +             '._'-._            +      ",
            offset .. "                                                      ```                    ",
            offset .. "                             +                                               ",
            offset .. "                      /^--^\\     /^--^\\     /^--^\\                       ",
            offset .. "      +               \\____/     \\____/     \\____/                       ",
            offset .. "                     /      \\   /      \\   /      \\         +            ",
            offset .. "                    |        | |        | |        |                     ",
            offset .. "                     \\__  __/   \\__  __/   \\__  __/                      ",
            offset .. "|^|^|^|^|^|^|^|^|^|^|^|^\\ \\^|^|^|^/ /^|^|^|^|^\\ \\^|^|^|^|^|^|^|^|^|^|^|^|",
            offset .. "| | | | | | | | | | | | |\\ \\| | |/ /| | | | | | \\ \\ | | | | | | | | | | |",
            offset .. "| | | | | | | | | | | | / / | | |\\ \\| | | | | |/ /| | | | | | | | | | | |",
            offset .. "| | | | | | | | | | | | \\/| | | | \\/| | | | | |\\/ | | | | | | | | | | | |",
            offset .. "#########################################################################",
            offset .. "| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |",
            offset .. "| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |",
        }
        -- set menu items
        dashboard.section.buttons.val = {
            dashboard.button("n", "🆕 > New file", function()
                local fname = vim.fn.input("New file: ")
                if fname ~= "" then
                    vim.cmd("edit " .. fname)
                    vim.cmd("startinsert")
                end
            end),
            dashboard.button("f", "🔍 > Find file", ":Telescope find_files<CR>"),
            dashboard.button("w", "👀 > Find Word", ":Telescope live_grep<CR>"),
            dashboard.button("r", "📗 > Recent", ":Telescope oldfiles<CR>"),
            dashboard.button("q", "🚪 > Quit", ":qa<CR>"),
        }
        alpha.setup(dashboard.opts)
    end
}
