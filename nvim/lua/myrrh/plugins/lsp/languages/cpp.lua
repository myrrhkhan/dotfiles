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
		clangd = function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig["clangd"].setup({
				capabilities = capabilities,
				-- COMMENTED OUT - Enhanced clangd configuration:
				-- cmd = {
				--   "clangd",
				--   "--background-index",
				--   "--clang-tidy",
				--   "--header-insertion=iwyu",
				--   "--completion-style=detailed",
				--   "--function-arg-placeholders",
				--   "--fallback-style=llvm",
				-- },
			})
		end,
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
