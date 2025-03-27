return {
  "folke/persistence.nvim",
  enabled = false,
  event = "BufReadPre",
  opts = {},
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    vim.keymap.set("n", "<leader>qs", function() persistence.load() end, { desc = "load the session for the current directory" })
    vim.keymap.set("n", "<leader>qS", function() persistence.select() end, { desc = "select a session to load" })
    vim.keymap.set("n", "<leader>ql", function() persistence.load({ last = true }) end, { desc = "load the last session" })
    vim.keymap.set("n", "<leader>qd", function() persistence.stop() end, { desc = "stop Persistence => session won't be saved on exit" })
  end
}
