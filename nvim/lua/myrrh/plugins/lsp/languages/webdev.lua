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
		html = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("html", {
				capabilities = capabilities,
			})
			vim.lsp.enable("html")
		end,
		ts_ls = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("ts_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls")
		end,
		cssls = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("cssls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("cssls")
		end,
		tailwindcss = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("tailwindcss", {
				capabilities = capabilities,
			})
			vim.lsp.enable("tailwindcss")
		end,
		svelte = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("svelte", {
				capabilities = capabilities,
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
			})
			vim.lsp.enable("svelte")
		end,
		graphql = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("graphql", {
				capabilities = capabilities,
				filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			})
			vim.lsp.enable("graphql")
		end,
		emmet_ls = function()
			local lspconfig = vim.lsp.config
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig("emmet_ls", {
				capabilities = capabilities,
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			})
			vim.lsp.enable("emmet_ls")
		end,
	},
}
