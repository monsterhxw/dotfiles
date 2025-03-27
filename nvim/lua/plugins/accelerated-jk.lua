return {
  "rhysd/accelerated-jk",
  -- "rainbowhxch/accelerated-jk.nvim",
  keys = { { "j", mode = "n" }, { "k", mode = "n" }, },
  config = function(_, opts)
    vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)")
    vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)")
  end,
}
