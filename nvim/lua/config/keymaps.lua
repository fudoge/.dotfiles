local mapKey = require("utils.keyMapper").mapKey

-- Neotree toggle
mapKey("<leader>e", ":Neotree toggle<cr>")

-- pane navigation
mapKey("<C-h>", "<C-w>h") -- Left
mapKey("<C-j>", "<C-w>j") -- Down
mapKey("<C-k>", "<C-w>k") -- Up
mapKey("<C-l>", "<C-w>l") -- Right

-- clear search highlights
mapKey("<leader>h", ":nohlsearch<CR>")

-- indent
mapKey("<", "<gv", "v")
mapKey(">", ">gv", "v")

-- Move to previous/next
mapKey("<A-,>", "<Cmd>BufferPrevious<CR>", "n")
mapKey("<A-.>", "<Cmd>BufferNext<CR>", "n")

-- Re-order to previous/next
mapKey("<A-<>", "<Cmd>BufferMovePrevious<CR>", "n")
mapKey("<A->>", "<Cmd>BufferMoveNext<CR>", "n")

-- Goto buffer in position...
mapKey("<A-1>", "<Cmd>BufferGoto 1<CR>", "n")
mapKey("<A-2>", "<Cmd>BufferGoto 2<CR>", "n")
mapKey("<A-3>", "<Cmd>BufferGoto 3<CR>", "n")
mapKey("<A-4>", "<Cmd>BufferGoto 4<CR>", "n")
mapKey("<A-5>", "<Cmd>BufferGoto 5<CR>", "n")
mapKey("<A-6>", "<Cmd>BufferGoto 6<CR>", "n")
mapKey("<A-7>", "<Cmd>BufferGoto 7<CR>", "n")
mapKey("<A-8>", "<Cmd>BufferGoto 8<CR>", "n")
mapKey("<A-9>", "<Cmd>BufferGoto 9<CR>", "n")
mapKey("<A-0>", "<Cmd>BufferLast<CR>", "n")

-- Pin/unpin buffer
mapKey("<A-p>", "<Cmd>BufferPin<CR>", "n")

-- Close buffer
mapKey("<A-c>", "<Cmd>BufferClose<CR>", "n")

-- Magic buffer-picking mode
mapKey("<C-p>", "<Cmd>BufferPick<CR>", "n")

-- Sort automatically by...
mapKey("<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", "n")
mapKey("<Space>bn", "<Cmd>BufferOrderByName<CR>", "n")
mapKey("<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", "n")
mapKey("<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", "n")
mapKey("<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", "n")

-- FindCmdline
mapKey(":", "<cmd>FineCmdline<CR>", "n")
