return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-Left>",  "<cmd>TmuxNavigateLeft<cr>",     desc = "Pane Left" },
    { "<c-Down>",  "<cmd>TmuxNavigateDown<cr>",     desc = "Pane Down" },
    { "<c-Up>",    "<cmd>TmuxNavigateUp<cr>",       desc = "Pane Up" },
    { "<c-Right>", "<cmd>TmuxNavigateRight<cr>",    desc = "Pane Right" },
    { "<c-\\>",    "<cmd>TmuxNavigatePrevious<cr>", desc = "Pane Prev" },
  },
}
