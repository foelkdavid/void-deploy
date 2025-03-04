return {
	--
	{
		"williamboman/mason.nvim",
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
	},

	--- requirement for some formatters and other stuff
	{
		"nvim-lua/plenary.nvim",
	},

	--- lua formatting etc.
	{
		"wesleimp/stylua.nvim",
	},

	--- latex stuff
	{
		"lervag/vimtex",
	},

	{
		--- markdown stuff
		"preservim/vim-markdown",
	},

	{
		--- rust stuff
		"alx741/vim-rustfmt",
	},

	{
		--- c/c++ stuff
		"bfrg/vim-c-cpp-modern",
	},

	--- treesitter -> improved syntax-highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Automatically update parsers after installation
		event = { "BufReadPost", "BufNewFile" }, -- Load Treesitter when opening a file
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- Optional: for better text objects
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "go", "gomod", "gosum", "gowork" }, -- Ensure Go support is installed
				highlight = { enable = true }, -- Enable syntax highlighting
				indent = { enable = true }, -- Enable Treesitter-based indentation
			})
		end,
	},
}
