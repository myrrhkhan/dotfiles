return {
	"daeyun/vim-matlab",
	config = function()
		local thisgroup = vim.api.nvim_create_augroup("matlab", { clear = true })
		vim.api.nvim_create_autocmd({ "VimEnter" }, {
			group = thisgroup,
			command = "UpdateRemotePlugins",
		})
	end,
}
