return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },       -- 파일을 열 때 자동 로드
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,           -- 현재 라인에 blame 표시
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- 간단한 키맵 설정
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Git 관련 키맵
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "<leader>hs", gs.stage_hunk)
        map("n", "<leader>hr", gs.reset_hunk)
        map("n", "<leader>hb", gs.blame_line)
        map("n", "<leader>hp", gs.preview_hunk)
      end,
    })
  end,
}
