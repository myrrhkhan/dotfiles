local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
	{ import = "myrrh.plugins" },
	{ import = "myrrh.plugins.coding" },
	{ import = "myrrh.plugins.debugging" },
	{ import = "myrrh.plugins.editor" },
	{ import = "myrrh.plugins.git" },
	{ import = "myrrh.plugins.lsp" },
	{ import = "myrrh.plugins.lsp.langs.plugins" },
	{ import = "myrrh.plugins.media" },
	{ import = "myrrh.plugins.navigation" },
	{ import = "myrrh.plugins.notes" },
	-- { import = "myrrh.plugins.session" },
	{ import = "myrrh.plugins.terminal" },
	{ import = "myrrh.plugins.treesitter" },
	{ import = "myrrh.plugins.ui" },
}, {
	checker = {
		enabled = true,
	},
})
