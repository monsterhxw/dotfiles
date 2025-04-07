return {
  "folke/todo-comments.nvim",
  -- event = "VimEnter",
  event = "BufReadPost",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = { 
    signs = false
  },
}
