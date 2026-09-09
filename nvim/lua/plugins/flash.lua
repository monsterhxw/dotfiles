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
  -- WORKAROUND folke/flash.nvim#480: search-mode labels lag one keystroke on nvim >= 0.12
  -- (neovim#35254 moved CmdlineChanged after the incsearch redraw).
  -- To remove: delete this whole `config` function; lazy.nvim will call setup(opts) itself.
  -- Remove once #480 is closed or PR #488 (or an equivalent fix) is merged.
  config = function(_, opts)
    require("flash").setup(opts)

    local search = require("flash.plugins.search")
    local State = require("flash.state")
    local seen_cmdline ---@type string? cmdline text flash last processed via CmdlineChanged

    -- (a) Same as PR #488: repaint after each update so new labels show immediately.
    local update = search.update
    ---@diagnostic disable-next-line: duplicate-set-field
    search.update = function(check_jump)
      update(check_jump)
      seen_cmdline = vim.fn.getcmdline()
      if vim.api.nvim__redraw then
        vim.api.nvim__redraw({ flush = true })
      else
        vim.cmd("redraw")
      end
    end

    -- (b) Not in #488: if the pressed label yields a pattern with no match, incsearch scrolls
    -- back and redraws before CmdlineChanged; flash's redraw hook then rebuilds matches for the
    -- new viewport and drops the labels check_jump() needs. Skip that rebuild while the cmdline
    -- is ahead of what flash has processed.
    local state_update = State.update
    ---@diagnostic disable-next-line: duplicate-set-field
    State.update = function(self, opts)
      if
        self == search.state
        and not (opts and opts.pattern)
        and State.is_search()
        and vim.fn.getcmdline() ~= seen_cmdline
      then
        return
      end
      return state_update(self, opts)
    end

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      group = vim.api.nvim_create_augroup("flash_workaround", { clear = true }),
      callback = function()
        seen_cmdline = nil
      end,
    })
  end,
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}
