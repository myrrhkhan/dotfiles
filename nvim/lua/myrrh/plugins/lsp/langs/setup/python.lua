local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()
return {
	config_lsp = function()
		-- configure python server
		lspconfig["pyright"].setup({
			capabilities = capabilities,
		})
	end,
}
