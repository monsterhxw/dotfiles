return {
  "echasnovski/mini.cursorword",
  enabled = true,
  event = "VeryLazy",
  opts = {
    delay = 1000,
  },
  config = function(_, opts)
    require("mini.cursorword").setup(opts)
    vim.api.nvim_set_hl(0, 'MiniCursorword', { underline = true })
    vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent',{ link = 'MiniCursorword' })
  end,
}
