--------------------------------------------------
-- Performance Optimization
--------------------------------------------------
-- Enable Neovim's native Lua loader for faster startup
vim.loader.enable() 
-- Reduce time for cursor hold events (ms)
vim.opt.updatetime = 100
-- Time to wait for mapped sequence to complete (ms)
vim.opt.timeoutlen = 300

--------------------------------------------------
-- User Interface
--------------------------------------------------
-- Don't show mode in command line (use statusline instead)
vim.opt.showmode = false
-- Highlight the current line
vim.opt.cursorline = true
-- Always show the sign column
vim.opt.signcolumn = "yes"
-- Keep 10 lines visible above/below cursor when scrolling
vim.opt.scrolloff = 10
-- Show line numbers
vim.opt.number = true
-- Show relative line numbers
vim.opt.relativenumber = true
-- Enable true color support
vim.opt.termguicolors = true
-- Set window title to reflect current file
vim.opt.title = true
-- Enable mouse support in all modes
vim.opt.mouse = "a"
-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

--------------------------------------------------
-- Text Editing and Indentation
--------------------------------------------------
-- Number of spaces a tab counts for
vim.opt.tabstop = 4
-- Number of spaces for each indentation level
vim.opt.shiftwidth = 4
-- Convert tabs to spaces
vim.opt.expandtab = true
-- Round indent to multiple of shiftwidth
vim.opt.shiftround = true
-- Insert indents automatically
vim.opt.smartindent = true
-- Break lines at word boundaries. (requires `vim.opt.wrap = true`)
vim.opt.linebreak = true
-- Preserve indentation in wrapped lines
vim.opt.breakindent = true

--------------------------------------------------
-- Search and Completion
--------------------------------------------------
-- Ignore case in search patterns
vim.opt.ignorecase = true
-- Override ignorecase when pattern has uppercase
vim.opt.smartcase = true
-- Configure completion behavior. 
-- Recommended by `nvim-cmp`, See: https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples
vim.opt.completeopt = {"menu", "menuone", "noselect"}

--------------------------------------------------
-- Window and Buffer Management
--------------------------------------------------
-- Open new horizontal splits below
vim.opt.splitbelow = true
-- Open new vertical splits to the right
vim.opt.splitright = true

--------------------------------------------------
-- File Handling
--------------------------------------------------
-- Disable swap files
vim.opt.swapfile = false
-- Enable persistent undo
vim.opt.undofile = true
-- Set directory (`~/.local/share/<NVIM_APPNAME>/undo`) for undo files
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
-- Allow loading local .nvim.lua/.nvimrc/.exrc files
vim.opt.exrc = true

--------------------------------------------------
-- Key Mappings
--------------------------------------------------
-- Set Space as the leader key
vim.g.mapleader = " "
-- Set Space as the local leader key
vim.g.maplocalleader = " "
