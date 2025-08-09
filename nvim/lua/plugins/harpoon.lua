return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- 추가
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        -- telescope 연동
        local conf = require("telescope.config").values

        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon with Telescope" })
        vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
        vim.keymap.set("n", "<leader>hd", function()
            local harpoon = require("harpoon")
            local list = harpoon:list()

            local current_path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
            if not current_path then
                print("❌ Cannot resolve current file path.")
                return
            end

            for i, item in ipairs(list.items) do
                local item_path = vim.loop.fs_realpath(vim.fn.fnamemodify(item.value, ":p"))
                if item_path == current_path then
                    list:remove_at(i)
                    print("✅ Removed from Harpoon: " .. current_path)
                    return
                end
            end

            print("ℹ️ Current file is not in Harpoon list.")
        end, { desc = "Remove current file from Harpoon" })
        vim.keymap.set("n", "<leader>hc", function()
            harpoon:list():clear()
        end, { desc = "Clear harpoon list" })
    end
}
