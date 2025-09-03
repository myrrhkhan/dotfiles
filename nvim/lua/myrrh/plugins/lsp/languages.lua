local language_manager = require("myrrh.plugins.lsp.languages")

-- Return all language-specific plugins
return language_manager.collect_plugins()
