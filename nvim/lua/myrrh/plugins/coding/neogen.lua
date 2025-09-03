return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		local neogen = require("neogen").setup()
		local keymap = vim.keymap
		keymap.set("n", "<leader>ne", "<cmd>Neogen<CR>", { desc = "Generate annotation" })
	end,
}
