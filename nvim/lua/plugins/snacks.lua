return {
  "folke/snacks.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indent = {
      enabled = true,
      chunk = {
        enabled = true,
      }
    }
  },
}
