return {
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
		"jay-babu/mason-null-ls.nvim",
	},
	event = { "VeryLazy" },
	config = function()
		local mason_null_ls = require("mason-null-ls")
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		mason_dap.setup({
			handlers = {},
		})
	end,
}
