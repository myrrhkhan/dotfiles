return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					include_surrounding_whitespace = true,
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>on"] = "@parameter.inner", -- swap object under cursor with next
					},
					swap_previous = {
						["<leader>op"] = "@parameter.inner", -- swap object under cursor with previous
					},
				},
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
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
				},
				auto_install = true,
			},
		})
	end,
}
