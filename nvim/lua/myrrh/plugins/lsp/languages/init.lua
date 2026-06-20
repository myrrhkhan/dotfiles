-- This file aggregates all language configurations
local M = {}

-- Define enabled languages
local enabled_languages = {
	"python",
	"cpp",
	"webdev",
	"rust",
	"lua",
	"swift",
}

-- Lazy-load language configurations to avoid circular dependencies
local function get_language_config(lang_name)
	return require("myrrh.plugins.lsp.languages." .. lang_name)
end

-- Collect specific tool types
function M.collect_tools(tool_type)
	local tools = {}
	for _, lang_name in ipairs(enabled_languages) do
		local lang_config = get_language_config(lang_name)
		if lang_config and lang_config[tool_type] then
			for _, tool in ipairs(lang_config[tool_type]) do
				if not vim.tbl_contains(tools, tool) then
					table.insert(tools, tool)
				end
			end
		end
	end
	return tools
end

-- Collect all language-specific plugins
function M.collect_plugins()
	local all_plugins = {}
	for _, lang_name in ipairs(enabled_languages) do
		local lang_config = get_language_config(lang_name)
		if lang_config and lang_config.plugins then
			for _, plugin in ipairs(lang_config.plugins) do
				table.insert(all_plugins, plugin)
			end
		end
	end
	return all_plugins
end

-- Setup LSP configurations
function M.setup_lsp_configs()
	for _, lang_name in ipairs(enabled_languages) do
		local lang_config = get_language_config(lang_name)
		if lang_config and lang_config.lsp_config then
			for server, config_func in pairs(lang_config.lsp_config) do
				if type(config_func) == "function" then
					config_func() -- Call the function to set up the LSP
				end
			end
		end
	end
end

return M
