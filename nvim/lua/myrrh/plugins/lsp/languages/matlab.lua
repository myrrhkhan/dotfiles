return {
	-- Mason tools (MATLAB language server isn't available in Mason)
	lsp_servers = {},
	formatters = {},
	linters = {},

	-- Language-specific plugins (from your existing matlab.lua)
	plugins = {
		{
			"danarth/matlab.lua",
			config = function()
				config =
					function()
						local thisgroup = vim.api.nvim_create_augroup("matlab", { clear = true })
						vim.api.nvim_create_autocmd({ "VimEnter" }, {
							group = thisgroup,
							command = "UpdateRemotePlugins",
						})
					end, require("matlab").setup()
			end,
		},
	},

	-- LSP config (if you have MATLAB LSP configured elsewhere)
	lsp_config = {},
}
