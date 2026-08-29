-- lua/plugins/neotree.lua
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			window = {
				position = "left",
				width = 30,
			},
			filesystem = {
				filtered_items = {
					visible = true, -- montre les fichiers cachés (.git, etc.)
					hide_dotfiles = false,
				},
			},
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer (sidebar)" },
		},
	},
}
