local lsp_setup = require("myrrh.plugins.lsp._lsp_setup").lsp_setup

return {
	-- Mason tools
	lsp_servers = { "pyright" },
	formatters = { "black" },
	linters = {},
	-- dap = { "debugpy" }, -- Uncommented when you want Python debugging

	-- Language-specific plugins
	plugins = {
		{
			"averms/black-nvim",
			ft = "python", -- Only load for Python files
			config = function()
				local keymap = vim.keymap
				keymap.set("n", "<c-q>", "<cmd>call black<CR>", { desc = "Format with black" })
			end,
		},
		-- COMMENTED OUT - Potential additions for better Python experience:
		-- {
		--   "linux-cultist/venv-selector.nvim",
		--   ft = "python",
		--   config = function()
		--     require("venv-selector").setup()
		--   end,
		-- },
	},

	-- Language-specific LSP configuration (from your setup/python.lua)
	lsp_config = {
		pyright = lsp_setup("pyright"),
	},

	-- COMMENTED OUT - Potential Python debugging setup:
	-- dap_config = {
	--   {
	--     type = "python",
	--     request = "launch",
	--     name = "Launch file",
	--     program = "${file}",
	--     pythonPath = function()
	--       return "/usr/bin/python3"
	--     end,
	--   },
	-- },
}
