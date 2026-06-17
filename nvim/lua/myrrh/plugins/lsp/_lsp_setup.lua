local function lsp_setup(name, extra_opts)
  return function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, extra_opts or {})

    vim.lsp.config(name, opts)
    vim.lsp.enable(name)
  end
end

return { lsp_setup = lsp_setup }
