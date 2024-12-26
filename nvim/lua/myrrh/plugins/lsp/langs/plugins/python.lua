local plugins = {
	{
		"averms/black-nvim",
		config = function()
			local keymap = vim.keymap
			keymap.set("n", "<c-q>", "<cmd>call black<CR>", { desc = "Format with black" })
		end,
	},
}
return plugins
