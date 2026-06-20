local lsp_setup = require("myrrh.plugins.lsp._lsp_setup").lsp_setup

return {
	-- Mason tools
	lsp_servers = {},
	formatters = {},
	linters = {},
	dap = {},

	-- Language-specific plugins
	plugins = {},

	-- Language-specific LSP configuration (from your setup/cpp.lua)
	lsp_config = {
		swift = lsp_setup("swift", {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift" },
			root_markers = {
				".git",
				"compile_commands.json",
				".sourcekit-lsp",
				"Package.swift",
			},
			get_language_id = function(_, ftype)
				return ftype
			end,
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
				textDocument = {
					diagnostic = {
						dynamicRegistration = true,
						relatedDocumentSupport = true,
					},
				},
			},
		}),
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
