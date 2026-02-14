return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		workspaces = {
			{
				name = "Class Notes",
				path = "/Users/myrrh/Documents/onedrivelocalarchive/Class Notes",
			},
			{
				name = "no-vault",
				path = function()
					-- alternatively use the CWD:
					-- return assert(vim.fn.getcwd())
					return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
				end,
				overrides = {
					notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
					new_notes_location = "current_dir",
					templates = {
						folder = vim.NIL,
					},
					disable_frontmatter = true,
				},
			},
			{
				name = "dynamic",
				path = function()
					local current_file = vim.api.nvim_buf_get_name(0)
					local current_dir = vim.fs.dirname(current_file)

					-- Search upward for .obsidian folder
					local obsidian_root = vim.fs.find(".obsidian", {
						upward = true,
						path = current_dir,
						type = "directory",
					})[1]

					if obsidian_root then
						return vim.fs.dirname(obsidian_root)
					else
						return current_dir
					end
				end,
				overrides = {
					notes_subdir = vim.NIL,
					new_notes_location = "current_dir",
					templates = {
						folder = vim.NIL,
					},
					disable_frontmatter = true,
				},
			},
		},

		attachments = {
			img_folder = "static",
		},
	},
}
