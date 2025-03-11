-- File detecting
vim.filetype.add({
  pattern = {
    [".*%.gitconfig%..*"] = "gitconfig",
    [".*/%.ssh/config%.d/.*"] = "sshconfig",
    [".*/ssh/config"] = "sshconfig",
    [".*/ssh/config%.d/.*"] = "sshconfig",
  },
})

