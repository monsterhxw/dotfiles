return {
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
}
