return {
	-- 1. Core Treesitter Plugin Configuration
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			-- Main features configured via the standard opts table
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = true,
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"svelte",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"java",
				"cmake",
				"c",
				"cpp",
				"git_config",
				"git_rebase",
				"python",
				"rust",
				"latex",
				"vimdoc",
			},
		},
		config = function(_, opts)
			-- In newer versions, we pass configurations to the preferential main module
			-- or directly to the global preferences if required.
			-- This bypasses the deprecated/deleted configs.lua entirely.
			local configs = require("nvim-treesitter")
			-- Use modern initialization if available, or fallback gracefully
			pcall(function()
				configs.setup(opts)
			end)
		end,
	},

	-- 2. Treesitter Textobjects Plugin Configuration
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			-- Modern textobjects handles its own setup safely
			require("nvim-treesitter-textobjects").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj
						include_surrounding_whitespace = true,
						keymaps = {
							["ib"] = { query = "@code_cell.inner", desc = "in block" },
							["ab"] = { query = "@code_cell.outer", desc = "around block" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>on"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>op"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
