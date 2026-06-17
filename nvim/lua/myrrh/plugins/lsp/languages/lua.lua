return {
	-- Mason tools
	lsp_servers = { "lua_ls" },
	formatters = { "stylua" },
	linters = {},

	-- Language-specific plugins
	plugins = {},

	-- Language-specific LSP configuration (from your setup/lua.lua)
	lsp_config = {
		lua_ls = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
}
