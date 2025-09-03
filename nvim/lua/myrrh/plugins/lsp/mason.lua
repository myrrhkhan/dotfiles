local language_manager = require("myrrh.plugins.lsp.languages.init")

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_null_ls = require("mason-null-ls")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = language_manager.collect_tools("lsp_servers"),
			automatic_installation = true,
		})

		mason_null_ls.setup({
			ensure_installed = vim.list_extend(
				language_manager.collect_tools("formatters"),
				language_manager.collect_tools("linters")
			),
		})
	end,
}
