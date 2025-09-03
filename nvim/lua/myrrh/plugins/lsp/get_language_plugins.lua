local languages = require("myrrh.plugins.lsp.languages.init")

-- above gets the utility files
-- here, we actually call collect_plugins so we can
-- go through the files above, iterate through plugins table, and return them
return languages.collect_plugins()
