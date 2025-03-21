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
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },
  {
    "echasnovski/mini.cursorword",
    event = "VeryLazy",
    opts = {
      delay = 250,
    },
    config = function(_, opts)
      require("mini.cursorword").setup(opts)
      vim.api.nvim_set_hl(0, 'MiniCursorword', { underline = true })
      vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent',{ link = 'MiniCursorword' })
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "VeryLazy",
    config = function(_, opts)
      local hipatterns = require('mini.hipatterns')
      opts.highlighters = {
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      }
      hipatterns.setup(opts)
     end,
  },
}
