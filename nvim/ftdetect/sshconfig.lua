vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {
    vim.env.HOME .. "/.ssh/config.d/*",
    "*/ssh/config{,.d/*}"
  },
  callback = function()
    vim.bo.filetype = "sshconfig"
  end,
  desc = "Set filetype to sshconfig for SSH configuration files" 
})
