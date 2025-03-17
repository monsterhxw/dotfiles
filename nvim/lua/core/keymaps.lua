--------------------------------------------------
-- Key Mappings
--------------------------------------------------
-- Set Space as the leader key and the local leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable arrow keys in normal, insert and visual modes to enforce hjkl navigation
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>")

-- Smart j/k: Use gj/gk on wrapped lines, normal j/k with count prefix
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Copy to system clipboard in visual and normal modes
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "[Y]ank to system clipboard" })

-- Move selected lines up and down in visual mode
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Maintain Visual Selection After Indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Paste replace visual selection without copying it.
-- vim.keymap.set("v", "p", "\"_dP")
