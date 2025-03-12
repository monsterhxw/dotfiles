return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- style = "storm",
    transparent = true,
    on_highlights = function(hl, c)
      local linenr_fg = "#627E97"
      hl.LineNrAbove = { fg = linenr_fg }
      hl.LineNrBelow = { fg = linenr_fg }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
