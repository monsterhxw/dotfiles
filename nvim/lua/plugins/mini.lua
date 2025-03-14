return {
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    opts = {
      use_icons = vim.g.have_nerd_font
    },
    config = function(_, opts)
      local statusline = require("mini.statusline")
      statusline.setup(opts)
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
    },
  },
}
