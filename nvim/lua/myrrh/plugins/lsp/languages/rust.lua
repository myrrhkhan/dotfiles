return {
  -- Mason tools  
  lsp_servers = { "rust_analyzer" },
  formatters = {}, -- rust-analyzer handles formatting
  linters = {},
  dap = { "codelldb" }, -- You already have this configured
  
  -- Language-specific plugins (from your existing plugins/rust.lua)
  plugins = {
    {
      "rust-lang/rust.vim",
      ft = "rust",
      init = function()
        vim.g.rustfmt_autosave = 1
      end,
    },
    {
      "simrat39/rust-tools.nvim",
      dependencies = "neovim/nvim-lspconfig",
      ft = "rust",
      opts = {},
      config = function(_, opts)
        require("rust-tools").setup(opts)
      end,
    },
    {
      "saecki/crates.nvim",
      ft = { "rust", "toml" },
      config = function(_, opts)
        local crates = require("crates")
        crates.setup(opts)
        crates.show()
      end,
    },
    {
      "mrcjkb/rustaceanvim",
      version = "^5",
      lazy = false,
      ft = "rust",
      config = function()
        local mason_registry = require("mason-registry")
        local mason_packages = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")
        local extension_path = vim.fs.joinpath(mason_packages, "codelldb")
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
        local cfg = require("rustaceanvim.config")

        vim.g.rustaceanvim = {
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
        local keymap = vim.keymap
        keymap.set("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
      end,
    },
  },
  
  -- LSP config (rust-analyzer is handled by rustaceanvim, so no manual setup needed)
  lsp_config = {},
}
