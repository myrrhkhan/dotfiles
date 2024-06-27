return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local keymap = vim.keymap
		local dap = require("dap")

		keymap.set("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint" })
		keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })

		dap.adapters.lldb = {
			type = "executable",
			-- absolute path is important here, otherwise the argument in the `runInTerminal` request will default to $CWD/lldb-vscode
			command = "/Users/myrrh/.vscode-oss/extensions/vsix-files/extension/debugAdapters/bin/OpenDebugAD7",
			name = "lldb",
		}
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				runInTerminal = true,
			},
		}
	end,
}
