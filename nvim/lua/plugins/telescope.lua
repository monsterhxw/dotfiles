return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  -- event = "VimEnter",
  cmd = "Telescope",
  keys = {
    { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "[S]earch [H]elp" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "[S]earch [K]eymaps" },
    { "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "[S]earch [F]iles" },
    { "<leader>ss", function() require("telescope.builtin").builtin() end, desc = "[S]earch [S]elect Telescope" },
    { "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "[S]earch current [W]ord" },
    { "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "[S]earch by [G]rep" },
    { "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "[S]earch [D]iagnostics" },
    { "<leader>sr", function() require("telescope.builtin").resume() end, desc = "[S]earch [R]esume" },
    { "<leader>s.", function() require("telescope.builtin").oldfiles() end, desc = '[S]earch Recent Files ("." for repeat)' },
    { "<leader>sc", function() require("telescope.builtin").commands() end, desc = "[S]earch [C]ommands" },
    { "<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "[ ] Find existing buffers" },
    -- Slightly advanced example of overriding default behavior and theme
    { "<leader>/", 
      function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown { winblend = 10, previewer = false, }
        )
      end, 
      desc = "[/] Fuzzily search in current buffer" 
    },
    -- It"s also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    { "<leader>s/",
      function()
        require("telescope.builtin").live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end, 
      desc = "[S]earch [/] in Open Files" 
    },
    -- Shortcut for searching your Neovim configuration files
    { "<leader>sn", 
      function()
        require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
      end, 
      desc = "[S]earch [N]eovim files" 
    },
  },
  config = function(_, opts)
    require("telescope").setup {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                          -- the default case_mode is "smart_case"
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    }
      -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require('telescope').load_extension, 'ui-select')
  end,
}
