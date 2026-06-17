	local lsp_setup = require("myrrh.plugins.lsp._lsp_setup").lsp_setup

	return {
		-- Mason tools
		lsp_servers = { "lua_ls" },
		formatters = { "stylua" },
		linters = {},

		-- Language-specific plugins
		plugins = {},

		-- Language-specific LSP configuration (from your setup/lua.lua)
		lsp_config = {
			lua_ls = lsp_setup("lua_ls", {
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
			}),
		},
	}
