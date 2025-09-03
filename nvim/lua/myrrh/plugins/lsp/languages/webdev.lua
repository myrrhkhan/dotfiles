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
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["html"].setup({
        capabilities = capabilities,
      })
    end,
    ts_ls = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["ts_ls"].setup({
        capabilities = capabilities,
      })
    end,
    cssls = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["cssls"].setup({
        capabilities = capabilities,
      })
    end,
    tailwindcss = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
      })
    end,
    svelte = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["svelte"].setup({
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
    end,
    graphql = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["graphql"].setup({
        capabilities = capabilities,
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      })
    end,
    emmet_ls = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      
      lspconfig["emmet_ls"].setup({
        capabilities = capabilities,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      })
    end,
  },
}
