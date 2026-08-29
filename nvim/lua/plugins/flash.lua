return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      search = {
        enabled = true,
      },
      char = {
        jump_labels = true,
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)

    -- Workaround for folke/flash.nvim#480 (fix PR #488 unmerged): since neovim/neovim#35254,
    -- CmdlineChanged fires after the incsearch redraw, so new labels are not painted until the
    -- next keypress. Pressing a label that is still on screen extends the search instead of jumping.
    local search = require("flash.plugins.search")
    local update = search.update
    ---@diagnostic disable-next-line: duplicate-set-field
    search.update = function(check_jump)
      update(check_jump)
      if vim.api.nvim__redraw then
        vim.api.nvim__redraw({ flush = true })
      else
        vim.cmd("redraw")
      end
    end
  end,
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}
