return {
	"mfussenegger/nvim-dap",
	config = function()
		local keymap = vim.keymap
		local dap = require("dap")

		keymap.set("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint" })
		keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })

		dap.configurations.cpp = {
			{
				type = "cpp",
				request = "launch",
				name = "CPP debug",
			},
		}
	end,
}
