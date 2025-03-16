return {
  { 
    "tpope/vim-sleuth",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "Darazaki/indent-o-matic",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "farmergreg/vim-lastplace",
    event = { "BufReadPre", "BufNewFile" },
  },
}
