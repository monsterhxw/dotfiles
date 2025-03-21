-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Like vim-cool
-- See: https://www.reddit.com/r/neovim/comments/1ct2w2h/comment/l4bgvn1
vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('auto-hlsearch', { clear = true }),
  callback = function ()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function () vim.cmd.nohlsearch() end)
    end
  end
})

-- Replace this with 'ScrollEOF' plugin
-- See: https://www.reddit.com/r/neovim/comments/198hoj6/comment/ki83dnw/
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
--   group = grp,
--   callback = function()
--     local win_h = vim.api.nvim_win_get_height(0)
--     local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
--     local dist = vim.fn.line "$" - vim.fn.line "."
--     local rem = vim.fn.line "w$" - vim.fn.line "w0" + 1
--     if dist < off and win_h - rem + dist < off then
--       local view = vim.fn.winsaveview()
--       view.topline = view.topline + off - (win_h - rem + dist)
--       vim.fn.winrestview(view)
--     end
--   end,
-- })
