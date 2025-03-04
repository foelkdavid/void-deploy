return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			routes = {
				{
					filter = { event = "notify", find = "No information available" },
					opts = { skip = true },
				},
			},
			presets = {
				lsp_doc_border = true,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	-- dont think i need it, maybe someday idk
	-- does not work, that was the problem
	-- { "hrsh7th/nvim-cmp" },
	-- { "hrsh7th/cmp-cmdline" },

	{ "ellisonleao/gruvbox.nvim", opts = {} },

	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		dependencies = { "DaikyXendo/nvim-material-icon" }, -- use if prefer nvim-web-devicons
	},

	{
		"junegunn/fzf",
	},
	{
		"nvim-telescope/telescope.nvim",
	},
}
