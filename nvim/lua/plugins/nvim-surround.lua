return {
  "kylechui/nvim-surround",
  version = "*",
  init = function()
    -- Disable default visual mode keymaps before plugin loads
    vim.g.nvim_surround_no_visual_mappings = true
  end,
  event = "VeryLazy",
  opts = {},
  keys = {
    { "gs", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround visual selection" },
    { "gS", "<Plug>(nvim-surround-visual-line)", mode = "x", desc = "Surround visual selection (line)" },
  },
}
