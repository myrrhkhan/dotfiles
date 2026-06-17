local lsp_setup = require("myrrh.plugins.lsp._lsp_setup").lsp_setup

return {
	-- Mason tools
	lsp_servers = { "clangd" },
	formatters = { "clang-format" },
	linters = {},
	dap = { "codelldb" }, -- Uncomment when you want C++ debugging

	-- Language-specific plugins
	plugins = {
		-- COMMENTED OUT - Potential C++ enhancements:
		-- {
		--   "p00f/clangd_extensions.nvim",
		--   ft = { "c", "cpp" },
		--   config = function()
		--     require("clangd_extensions").setup()
		--   end,
		-- },
	},

	-- Language-specific LSP configuration (from your setup/cpp.lua)
	lsp_config = {
		clangd = lsp_setup("clangd"),
	},

	-- COMMENTED OUT - C++ debugging setup:
	-- dap_config = {
	--   {
	--     name = "Launch",
	--     type = "codelldb",
	--     request = "launch",
	--     program = function()
	--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
	--     end,
	--     cwd = '${workspaceFolder}',
	--     stopOnEntry = false,
	--   },
	-- },
}
