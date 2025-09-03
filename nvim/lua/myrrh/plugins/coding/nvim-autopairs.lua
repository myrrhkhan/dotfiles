return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")
		local ts_conds = require("nvim-autopairs.ts-conds")

		npairs.setup({
			check_ts = true,
			enable_check_bracket_line = false,
			ignored_next_char = "[%w%.]",
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				before_key = "h",
				after_key = "l",
				cursor_pos_before = true,
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				manual_position = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		})

		npairs.add_rules({
			Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
			Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
		})

		npairs.add_rules(
			{
				Rule("$", "$", { "tex", "latex" })
					-- don't add a pair if the next character is %
					:with_pair(cond.not_after_regex("%%"))
					-- don't add a pair if  the previous character is xxx
					:with_pair(
						cond.not_before_regex("xxx", 3)
					)
					-- don't move right when repeat character
					:with_move(cond.none())
					-- don't delete if the next character is xx
					:with_del(cond.not_after_regex("xx"))
					-- disable adding a newline when you press <cr>
					:with_cr(cond.none()),
			},
			-- disable for .vim files, but it work for another filetypes
			Rule("a", "a", "-vim")
		)

		npairs.add_rules({
			Rule("$$", "$$", "tex"):with_pair(function(opts)
				print(vim.inspect(opts))
				if opts.line == "aa $$" then
					-- don't add pair on that line
					return false
				end
			end),
		})
	end,
}
