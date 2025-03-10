vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {
    ".gitconfig.*"
  },
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
  desc = "Set filetype to gitconfig for all .gitconfig.* files (e.g. .gitconfig.github, .gitconfig.gitee)"
})
