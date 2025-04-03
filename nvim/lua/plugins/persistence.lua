return {
  "folke/persistence.nvim",
  enabled = true,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "load the session for the current directory" },
    { "<leader>qS", function() require("persistence").select() end, desc = "select a session to load" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "load the last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "stop Persistence => session won't be saved on exit" },
  },
  opts = {},
}
