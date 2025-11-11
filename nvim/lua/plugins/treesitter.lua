return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  -- event = { "BufReadPost", "BufNewFile" },
  event = "VeryLazy",
  build = ":TSUpdate",
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = { 
      "bash", "c", "diff", "lua", "luadoc", "markdown", "markdown_inline",
      "query",
      "vim", "vimdoc", 
      "json", 
      -- "javascript", "typescript", "tsx", "html", "css",
      "yaml", "xml", "toml", "dockerfile", "gitignore", "git_config",
      -- "nginx",
      -- "groovy", "go",
      "java", "javadoc", 
      -- "kotlin", "python",
      "sql",
    },
    auto_install = true,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = { "tmux" },
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          -- You can optionally set descriptions to the mappings (used in the desc parameter of
          -- nvim_buf_set_keymap) which plugins like which-key display
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["ap"] = "@parameter.outer",
          ["ip"] = "@parameter.inner",
          -- You can also use captures from other query groups like `locals.scm`
          -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        },
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true or false
        include_surrounding_whitespace = false,
      },
    },
  },
}
