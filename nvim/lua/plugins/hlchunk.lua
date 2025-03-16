return {
  "shellRaining/hlchunk.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = {
      enable = true,
      style = "#00ffff",
    },
    indent = {
      enable = true,
    },
  },
}

