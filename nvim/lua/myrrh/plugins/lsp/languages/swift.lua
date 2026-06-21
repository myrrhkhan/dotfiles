local lsp_setup = require("myrrh.plugins.lsp._lsp_setup").lsp_setup

return {
	-- Mason tools
	lsp_servers = {},
	formatters = {},
	linters = {},
	dap = {},

	-- Language-specific plugins
	plugins = {
		{
			"devswiftzone/swift.nvim",
			ft = "swift",
			config = function()
				require("swift").setup({
					features = {
						formatter = {
							format_on_save = true,
							tool = "swift-format", -- or "swiftformat"
						},
					},
				})

				local debugger = require("swift.features.debugger")

				local map = vim.keymap.set

				-- Match your existing dap conventions
				map("n", "<leader>dc", debugger.continue, { desc = "Swift Debug Continue" })
				map("n", "<leader>db", debugger.toggle_breakpoint, { desc = "Swift Toggle Breakpoint" })
				map("n", "<leader>de", debugger.stop, { desc = "Swift Debug Stop" })

				-- Keep your existing dap step keys
				map("n", "<leader>dj", debugger.step_over, { desc = "Swift Step Over" })
				map("n", "<leader>dl", debugger.step_into, { desc = "Swift Step Into" })
				map("n", "<leader>dk", debugger.step_out, { desc = "Swift Step Out" })

				-- Swift-specific
				map("n", "<leader>dv", debugger.show_variables, { desc = "Swift Variables" })
				map("n", "<leader>dt", debugger.show_backtrace, { desc = "Swift Backtrace" })

				map("n", "<leader>ds", "<cmd>SwiftBuildAndDebug<CR>", {
					desc = "Swift Build & Debug",
				})

				map("n", "<leader>dS", "<cmd>SwiftBuildAndDebugTests<CR>", {
					desc = "Swift Debug Tests",
				})
			end,
		},
	},

	-- Language-specific LSP configuration (from your setup/cpp.lua)
	lsp_config = {
		--[[ 		swift = lsp_setup("swift", {
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
		}), ]]
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
