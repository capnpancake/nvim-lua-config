vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.g.mapleader = " "

-- lazy plugin manager config --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- key bindings --
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move full line down one
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move full line up one
vim.keymap.set("v", "<C-j>", "<C-w>j") -- go to below window
vim.keymap.set("v", "<C-k>", "<C-w>k") -- go to above window
vim.keymap.set("v", "<C-h>", "<C-w>h") -- go to left window
vim.keymap.set("v", "<C-l>", "<C-w>l") -- go to right window
-- vim.keymap.set("v", "<C-=>", "10<C-w>+") -- increase window split height
-- vim.keymap.set("v", "<C-->", "10<C-w>-") -- decrease window split height

-- telescope config --
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- lsp config --
--vim.lsp.set_log_level("debug")
vim.filetype.add({
	extension = { gml = 'gml' },
	filename = { ['.gml'] = 'gml' },
})

-- lua lsp --
vim.api.nvim_create_autocmd('filetype', {
	pattern = 'lua',
	callback = function()
		vim.lsp.start({
			name = 'lua-lsp',
			cmd = { 'lua-language-server', },
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim', }
					}
				}
			},
			root_dir = vim.fs.dirname(vim.fs.find({"init.lua"}, {upward = true})[1]),
			on_attach = function(client, bufnr)
				vim.keymap.set("n", "<C-z>", function()
					if vim.startswith(vim.trim(vim.fn.getline '.'), '--') then
						vim.cmd.normal('^2x')
					else
						vim.cmd.normal('I--')
					end
					vim.cmd.normal('j^')
				end)
			end,
		})
	end,
})

-- java lsp --
require('jdtls').start_or_attach({
	cmd = { 'java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', 'C:/tools/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
		'-configuration', 'C:/tools/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_win',
		'-data', 'c:/users/pancake/documents/java/workspaces'
	},
	--cmd = { 'jdtls' },
	root_dir = vim.fs.root(0, {'mvnw', 'gradlew'}),
})

-- gml lsp --
vim.api.nvim_create_autocmd('filetype', {
	pattern = "gml",
	callback = function()
		-- local rootFolder = "C:/GMS2Projects/bullet-matador"

		vim.lsp.start({
			name = "gml-lsp",
			cmd = { 'GameMakerLanguageServer', },
			cmd_cwd = 'C:\\Program Files\\GameMaker-Beta',
			autostart = true,
			filetypes = { 'gml', '.gml', },
			root_dir = "C:\\GMS2Projects\\bullet-matador", -- vim.fs.dirname(vim.fs.find({"bullet-matador.yyp"}, { upward = true })[1]),
			before_init = function(params, config)
				params.clientInfo = {
					name = "Neovim, Version=0.8.3, Culture=neutral, PublicKeyToken=null",
					version = "0.8.3",
				}
				params.initializationOptions = {
					runtimeDirectory = "C:\\ProgramData/GameMakerStudio2-Beta/Cache/runtimes\\runtime-2024.400.0.562",
					runtimeVersion = "2024.400.0.562",
					platforms = { "Windows", "HTML5", "android", "operagx", },
					modules = { "beta", "android", "HTML5", "Windows", "android.build_module", "HTML5.build_module", "Windows.build_module", "ci_build", "operagx", "operagx.build_module", "beta23", },
					locale = "US",
					languagePacks = { "C:\\Program Files\\GameMaker-Beta\\Plugins\\IDE_Localisation_English\\english.csv", },
					language = "English",
					prefabLibraryPath = "C:\\ProgramData/GameMakerStudio2-Beta/Prefabs"
				}
			end,
			on_attach = function(client, bufnr)
				vim.keymap.set("n", "<C-z>", "I//<ESC>")
			end,
			--init_options = {
				--runtimeDirectory = "C:\\ProgramData/GameMakerStudio2-Beta/Cache/runtimes\\runtime-2024.400.0.562",
				--runtimeVersion = "2024.400.0.562",
				--platforms = { "Windows", "Mac", "Linux", "HTML5", "android", "ios", "tvos", "operagx", },
				--modules = { "beta", "android", "ios", "HTML5", "Linux", "Mac", "Windows", "android.build_module", "HTML5.build_module", "ios.build_module", "Linux.build_module", "Mac.build_module", "Windows.build_module", "tvos", "tvos.build_module", "ci_build", "operagx", "operagx.build_module", "beta23", },
				--locale = "US",
				--languagePacks = { "C:\\Program Files\\GameMaker-Beta\\Plugins\\IDE_Localisation_English\\english.csv", },
				--language = "English",
				--prefabLibraryPath = "C:\\ProgramData/GameMakerStudio2-Beta/Prefabs"
			--},
		})
	end,
})

