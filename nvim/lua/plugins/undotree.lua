return {
  "mbbill/undotree",
  cmd = { "UndotreeToggle" },
  init = function()
    --- Options
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SplitWidth = 35
    vim.g.undotree_DiffpanelHeight = 15
    --- Keymaps
    vim.keymap.set("ca", "undot", "UndotreeToggle")
  end,
}
