local transparent = true
local bg = "#011628"
local bg_dark = "#011423"
local bg_highlight = "#143652"
-- local bg_search = "#0A64AC"
local bg_search = "#0B9E7B"
local bg_visual = "#275378"
local fg = "#CBE0F0"
local fg_dark = "#B4D0E9"
local fg_gutter = "#627E97"
local border = "#547998"

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = transparent,
    styles = {
      sidebars = transparent and "transparent" or "dark",
      floats = transparent and "transparent" or "dark",
    },
    on_colors = function(colors)
      -- colors.bg = bg
      colors.bg_highlight = bg_highlight
      colors.bg_popup = bg_dark
      colors.bg_search = bg_search
      colors.bg_visual = bg_visual
      colors.border = border

      local bg_trsp = transparent and colors.none or bg_dark
      colors.bg_dark = bg_trsp
      colors.bg_float = bg_trsp
      colors.bg_sidebar = bg_trsp
      colors.bg_statusline = bg_trsp

      colors.fg = fg
      colors.fg_dark = fg_dark
      colors.fg_float = fg
      colors.fg_gutter = fg_gutter
      colors.fg_sidebar = fg_dark
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
