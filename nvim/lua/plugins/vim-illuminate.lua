return {
  "RRethy/vim-illuminate",
  enabled = false,
  event = "VeryLazy",
  opts = {
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
    vim.api.nvim_set_hl(0, 'illuminatedwordtext', { underline = true })
    vim.api.nvim_set_hl(0, 'illuminatedwordread', { underline = true })
    vim.api.nvim_set_hl(0, 'illuminatedwordwrite', { underline = true })
  end,
}
