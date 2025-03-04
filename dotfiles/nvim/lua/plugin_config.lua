require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").gopls.setup({
	-- Your gopls setup options here
})

require("lspconfig").clangd.setup({})

require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			"target/.*", -- Ignore the Rust target directory
		},
	},
})
