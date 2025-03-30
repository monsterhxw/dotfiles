return {
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
}
