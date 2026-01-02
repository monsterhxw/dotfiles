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
    { "<S-Left>",  "<cmd>TmuxNavigateLeft<cr>",     desc = "Pane Left" },
    { "<S-Down>",  "<cmd>TmuxNavigateDown<cr>",     desc = "Pane Down" },
    { "<S-Up>",    "<cmd>TmuxNavigateUp<cr>",       desc = "Pane Up" },
    { "<S-Right>", "<cmd>TmuxNavigateRight<cr>",    desc = "Pane Right" },
    { "<c-\\>",    "<cmd>TmuxNavigatePrevious<cr>", desc = "Pane Prev" },
  },
}
