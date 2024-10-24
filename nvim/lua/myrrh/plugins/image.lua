return {
	{
		-- luarocks.nvim is a Neovim plugin designed to streamline the installation
		-- of luarocks packages directly within Neovim. It simplifies the process
		-- of managing Lua dependencies, ensuring a hassle-free experience for
		-- Neovim users.
		-- https://github.com/vhyrro/luarocks.nvim
		"vhyrro/luarocks.nvim",
		-- this plugin needs to run before anything else
		priority = 1001,
		opts = {
			rocks = { "magick" },
		},
	},
	{
		"3rd/image.nvim",
		dependencies = { "luarocks.nvim" },
		config = function()
			require("image").setup({
				backend = "kitty",
				integrations = {
					filetypes = { "markdown, vimwiki, ipynb" },
				},
				max_width = 100,
				max_height = 12,
				max_height_window_percentage = math.huge,
				max_width_window_percentage = math.huge,
				window_overlap_clear_enabled = true,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			})
		end,
	},
}
