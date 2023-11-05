return {
	"akinsho/toggleterm.nvim",
	config = function()
		local terminal = require("toggleterm")
		terminal.setup({
			hide_numbers = true,
			direction = "float",
		})

		local keymap = vim.keymap
		keymap.set("n", "<C-S-'?", "<cmd>ToggleTerm<CR>")
	end,
}
