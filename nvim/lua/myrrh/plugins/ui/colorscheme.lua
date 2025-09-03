return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		--require("catppuccin").setup({
		--    flavor = "latte",
		--})
		vim.cmd([[colorscheme catppuccin-frappe]])
	end,
}
