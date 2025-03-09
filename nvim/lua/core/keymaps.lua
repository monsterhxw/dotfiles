--------------------------------------------------
-- Key Mappings
--------------------------------------------------
-- Set Space as the leader key
vim.g.mapleader = " "
-- Set Space as the local leader key
vim.g.maplocalleader = " "
-- Disable arrow keys in normal, insert and visual modes to enforce hjkl navigation
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>")
-- Move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
-- Copy to system clipboard in visual and normal modes
-- vim.keymap.set({ "v", "n" }, "<leader>y", "\"+y")
