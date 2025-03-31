return {
  "echasnovski/mini.files",
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    {
      "<leader>Et",
      function()
        local trash_dir = vim.fn.stdpath("data") .. "/mini.files/trash"
        vim.fn.system("open " .. vim.fn.shellescape(trash_dir))
      end,
      desc = "Reveal mini.files trash directory in Finder",
    },
  },
  opts = {
    options = {
      -- stdpath('data')/mini.files/trash, 
      --   etc. $HOME/.local/share/nvim/mini.files/trash
      permanent_delete = false,
    },
    mappings = {
      close       = "q",
      go_in       = "l",
      go_in_plus  = "L",
      go_out      = "h",
      go_out_plus = "H",
      mark_goto   = "'",
      mark_set    = "m",
      reset       = "<BS>",
      reveal_cwd  = "@",
      show_help   = "g?",
      synchronize = "s",
      trim_left   = "<",
      trim_right  = ">",
    },
    windows = {
      preview = true,
    },
  },
}
