return {
  "lewis6991/gitsigns.nvim",
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    signs = {
      add          = { text = "+" },
      delete       = { text = "-" },
    },
    -- numhl = true,
    linehl = true,
    -- word_diff = true,
    -- current_line_blame = true,
    -- current_line_blame_opts = {
    --   delay = 500,
    -- },
    -- higher than diagnostic,todo signs. lower than dapui breakpoint sign
    -- See: https://www.reddit.com/r/neovim/comments/1cqf4qx/comment/l3rmldj/
    sign_priority = 15, 
  },
}
