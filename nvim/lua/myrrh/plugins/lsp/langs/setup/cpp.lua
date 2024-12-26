local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

return {
	config_lsp = function()
		-- configure c/c++ server
		lspconfig["clangd"].setup({
			capabilities = capabilities,
		})
	end,
}
