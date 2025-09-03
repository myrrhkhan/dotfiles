local language_manager = require("myrrh.plugins.lsp.languages.init")

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
	config = function()
		-- Setup language-specific LSP configurations
		language_manager.setup_lsp_configs()

		-- Your existing keymap configurations
		local keymap = vim.keymap
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references" })
		keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Show LSP definitions" })
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations" })
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Show LSP type definitions" })
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions" })
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
		keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
		keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
		keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
		keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" })
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })
	end,
}
