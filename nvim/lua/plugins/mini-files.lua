return {
  "echasnovski/mini.files",
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    {
      "<leader>Et",
      function()
        local trash_dir = vim.fn.stdpath("data") .. "/mini.files/trash"
        vim.fn.system("open " .. vim.fn.shellescape(trash_dir))
      end,
      desc = "Reveal mini.files trash directory in Finder",
    },
  },
  opts = {
    options = {
      -- stdpath('data')/mini.files/trash, 
      --   etc. $HOME/.local/share/nvim/mini.files/trash
      permanent_delete = false,
    },
    mappings = {
      close       = "q",
      go_in       = "l",
      go_in_plus  = "L",
      go_out      = "h",
      go_out_plus = "H",
      mark_goto   = "'",
      mark_set    = "m",
      reset       = "<BS>",
      reveal_cwd  = "@",
      show_help   = "g?",
      synchronize = "s",
      trim_left   = "<",
      trim_right  = ">",
    },
    windows = {
      preview = true,
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)

    -- See: https://www.lazyvim.org/extras/editor/mini-files
    local map_split = function(buf_id, lhs, direction, close_on_file)
      local rhs = function()
        local new_target_window
        local cur_target_window = require("mini.files").get_explorer_state().target_window

        if cur_target_window ~= nil then
          vim.api.nvim_win_call(cur_target_window, function()
            vim.cmd("belowright " .. direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
          end)

          require("mini.files").set_target_window(new_target_window)
          require("mini.files").go_in({ close_on_file = close_on_file })
        end
      end

      local desc = "Open in " .. direction .. " split"
      if close_on_file then
        desc = desc .. " and close"
      end
      vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id

        map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "gs", "horizontal", false)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "gv", "vertical", false)

        map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal_plus or "gS", "horizontal", true)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "gV", "vertical", true)
      end,
    })

  end,
}
