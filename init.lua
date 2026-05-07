vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- plugins start --
vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/numtostr/comment.nvim" },
})
require('language-server-config')
require('commenting-config')
require('terminal-config')
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "svelte", "html", "css", "javascript", "typescript", "lua" },
	callback = function() vim.treesitter.start() end,
})

vim.cmd("colorscheme kanagawa")
-- plugins end --

-- telescope config --
require('telescope').setup({
	defaults = {
		file_ignore_patterns = { "node_modules", "pack" },
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
-- telescope end --

-- diagnostics start --
vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = true,
	float = true
})
-- diagnostics end --

-- key bindings --
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- move full line down one
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv") -- move full line up one
vim.keymap.set({'n', 'v'}, '<C-j>', '<C-w>j') -- go to below window
vim.keymap.set({'n', 'v'}, '<C-k>', '<C-w>k') -- go to above window
vim.keymap.set({'n', 'v'}, '<C-h>', '<C-w>h') -- go to left window
vim.keymap.set({'n', 'v'}, '<C-l>', '<C-w>l') -- go to right window
vim.keymap.set({'n', 'v'}, '<leader>L', function() vim.cmd('30Lex') end) -- open Lexplore netrw
-- vim.keymap.set('v', '<C-=>', '10<C-w>+') -- increase window split height
-- vim.keymap.set('v', '<C-->', '10<C-w>-') -- decrease window split height

-- netrw config --
vim.g.netrw_liststyle = 3			-- tree view
vim.g.netrw_usetab = 10
vim.g.netrw_browse_split = 4  -- open files in previous window
vim.g.netrw_altv = 1          -- vertical splits open to the right

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function(args)
		if vim.bo[args.buf].filetype == "netrw" or vim.bo[args.buf].buftype ~= "" then
			return
		end
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "netrw" then
				pcall(vim.api.nvim_win_close, win, false)
			end
		end
	end,
})

local function explore_search(scope)
	local prefix = ({ cur = '*/', rec = '**/', grep = '**//' })[scope]
	local pattern = vim.fn.input('Search (' .. scope .. '): ')
	if pattern == '' then return end
	vim.cmd('silent! Explore ' .. prefix .. pattern)
	vim.wo.statusline = ''
end

vim.keymap.set(
	'n', '<leader>ec', function() explore_search('cur') end,
	{ desc = 'Netrw search cwd' }
)
vim.keymap.set(
	'n', '<leader>er', function() explore_search('rec') end,
	{ desc = 'Netrw search recursive' }
)
vim.keymap.set(
	'n', '<leader>eg', function() explore_search('grep') end,
	{ desc = "Netrw grep contents" }
)

