return {
	"benlubas/molten-nvim",
	dependencies = {
		"3rd/image.nvim",
		"GCBallesteros/jupytext.nvim",
		"quarto-dev/quarto-nvim",
	},
	build = ":UpdateRemotePlugins",
	init = function()
		vim.g.molten_auto_open_output = false
		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 20
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
	end,
	config = function()
		vim.g.molten_virt_text_output = true

		-- automatically import output chunks from a jupyter notebook
		-- tries to find a kernel that matches the kernel in the jupyter notebook
		-- falls back to a kernel that matches the name of the active venv (if any)
		local imb = function(e) -- init molten buffer
			vim.schedule(function()
				local kernels = vim.fn.MoltenAvailableKernels()
				local try_kernel_name = function()
					local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
					return metadata.kernelspec.name
				end
				local ok, kernel_name = pcall(try_kernel_name)
				if not ok or not vim.tbl_contains(kernels, kernel_name) then
					kernel_name = nil
					local venv = os.getenv("VIRTUAL_ENV")
					if venv ~= nil then
						kernel_name = string.match(venv, "/.+/(.+)")
					end
				end
				if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
					vim.cmd(("MoltenInit %s"):format(kernel_name))
				end
				vim.cmd("MoltenImportOutput")
			end)
		end

		-- automatically import output chunks from a jupyter notebook
		vim.api.nvim_create_autocmd("BufAdd", {
			pattern = { "*.ipynb" },
			callback = imb,
		})

		-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = { "*.ipynb" },
			callback = function(e)
				if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
					imb(e)
				end
			end,
		})

		-- automatically export output chunks to a jupyter notebook on write
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.ipynb" },
			callback = function()
				if require("molten.status").initialized() == "Molten" then
					vim.cmd("MoltenExportOutput!")
				end
			end,
		})

		-- change the configuration when editing a python file
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.py",
			callback = function(e)
				if string.match(e.file, ".otter.") then
					return
				end
				if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
					vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
					vim.fn.MoltenUpdateOption("virt_text_output", false)
				else
					vim.g.molten_virt_lines_off_by_1 = false
					vim.g.molten_virt_text_output = false
				end
			end,
		})

		-- Undo those config changes when we go back to a markdown or quarto file
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = { "*.qmd", "*.md", "*.ipynb" },
			callback = function(e)
				if string.match(e.file, ".otter.") then
					return
				end
				if require("molten.status").initialized() == "Molten" then
					vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
					vim.fn.MoltenUpdateOption("virt_text_output", true)
				else
					vim.g.molten_virt_lines_off_by_1 = true
					vim.g.molten_virt_text_output = true
				end
			end,
		})

		vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
		vim.keymap.set(
			"n",
			"<leader>mr",
			":MoltenEvaluateOperator<CR>",
			{ silent = true, desc = "run operator selection" }
		)
		vim.keymap.set("n", "<leader>mrl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
		vim.keymap.set("n", "<leader>mrr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
		vim.keymap.set(
			"v",
			"<leader>mrv",
			":<C-u>MoltenEvaluateVisual<CR>gv",
			{ silent = true, desc = "evaluate visual selection" }
		)

		vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { silent = true, desc = "molten delete cell" })
		vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
		vim.keymap.set(
			"n",
			"<leader>mo",
			":noautocmd MoltenEnterOutput<CR>",
			{ silent = true, desc = "show/enter output" }
		)

		vim.keymap.set(
			"n",
			"<leader>mb",
			":MoltenOpenInBrowser<CR>",
			{ desc = "open output in browser", silent = true }
		)

		vim.keymap.set("n", "<leader>mnc", ":MoltenNext<CR>", { silent = true, desc = "molten next cell" })
		vim.keymap.set("n", "<leader>mpk", ":MoltenPrev<CR>", { silent = true, desc = "molten prev cell" })

		vim.keymap.set("n", "<leader>mr", ":MoltenRestart<CR>", { silent = true, desc = "molten restart" })

		-- Provide a command to create a blank new Python notebook
		-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
		-- if you use another language than Python, you should change it in the template.
		local default_notebook = [[
          {
            "cells": [
             {
              "cell_type": "markdown",
              "metadata": {},
              "source": [
                ""
              ]
             }
            ],
            "metadata": {
             "kernelspec": {
              "display_name": "Python 3",
              "language": "python",
              "name": "python3"
             },
             "language_info": {
              "codemirror_mode": {
                "name": "ipython"
              },
              "file_extension": ".py",
              "mimetype": "text/x-python",
              "name": "python",
              "nbconvert_exporter": "python",
              "pygments_lexer": "ipython3"
             }
            },
            "nbformat": 4,
            "nbformat_minor": 5
          }
        ]]

		local function new_notebook(filename)
			local path = filename .. ".ipynb"
			local file = io.open(path, "w")
			if file then
				file:write(default_notebook)
				file:close()
				vim.cmd("edit " .. path)
			else
				print("Error: Could not open new notebook file for writing.")
			end
		end

		vim.api.nvim_create_user_command("NewNotebook", function(opts)
			new_notebook(opts.args)
		end, {
			nargs = 1,
			complete = "file",
		})
	end,
}
