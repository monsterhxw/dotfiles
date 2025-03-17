return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    indent = {
      enabled = true,
      chunk = {
        enabled = true,
      },
    },
    dashboard = {
      enabled = true,
      sections = { 
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { 
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = { 2, 2 }
        },
        {
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 2 
        },
        { section = "startup" },
      },
    },
  },
}
