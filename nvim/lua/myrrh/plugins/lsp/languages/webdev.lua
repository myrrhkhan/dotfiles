local lsp_setup = require("myrrh.plugins.lsp._lsp_setup").lsp_setup

return {
	-- Mason tools
	lsp_servers = { "ts_ls", "html", "cssls", "tailwindcss", "svelte", "graphql", "emmet_ls" },
	formatters = { "prettier" },
	linters = {},

	-- Language-specific plugins
	plugins = {
		{
			"evanleck/vim-svelte", -- From your svelte.lua
		},
	},

	-- Language-specific LSP configuration (from your setup/webdev.lua)
	lsp_config = {
		html = lsp_setup("html"),
		ts_ls = lsp_setup("ts_ls"),
		cssls = lsp_setup("cssls"),
		tailwindcss = lsp_setup("tailwindcss"),
		svelte = lsp_setup("svelte", {
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						if client.name == "svelte" then
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end
					end,
				})
			end,
		}),
		graphql = lsp_setup("graphql", {
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		}),
		emmet_ls = lsp_setup("emmet_ls", {
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		}),
	},
}
