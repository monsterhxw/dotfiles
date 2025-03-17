return {
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      use_icons = vim.g.have_nerd_font
    },
    config = function(_, opts)
      local statusline = require("mini.statusline")
      statusline.setup(opts)
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
    },
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        left  = "H",
        right = "L",
        down  = "J",
        up    = "K",
        line_left = "", line_right = "", line_down = "", line_up = "", 
      },
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
  },
}
