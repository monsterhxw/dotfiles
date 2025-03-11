vim.filetype.add({
  pattern = {
    [".gitconfig.*"] = "gitconfig",
    ["*/{.,}ssh/config{,.d/*}"] = "sshconfig",
  },
})

