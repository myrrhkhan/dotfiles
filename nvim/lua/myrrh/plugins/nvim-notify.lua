return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({
			background_colour = "#282c34",
		})
	end,
}
