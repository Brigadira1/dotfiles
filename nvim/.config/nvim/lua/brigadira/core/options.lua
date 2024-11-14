vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for the sake of conciseness

opt.relativenumber = true
opt.number = true

opt.tabstop = 4 -- 4 spaces for tabs, python style
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "json", "yaml" },
	callback = function()
		opt.tabstop = 2
		opt.shiftwidth = 2
		opt.softtabstop = 2
		opt.expandtab = true
	end,
})
opt.wrap = false

-- Set timeout values for matchparen plugin to reduce sluggishness
-- vim.g.matchparen_timeout = 1000
-- vim.g.matchparen_insert_timeout = 1000
vim.g.loaded_matchparen = 1

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive search

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be white or dark will be dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.conceallevel = 2
opt.swapfile = false
