vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

require("which-key").setup({
	preset = "modern",
	delay = 300,
	icons = { mappings = false },
	win = { border = "rounded" },
})

require("which-key").add({
	{ "<leader>b", group = "buffer" },
	{ "<leader>c", group = "code/claude" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git" },
	{ "<leader>h", group = "harpoon" },
	{ "<leader>l", group = "lsp" },
	{ "<leader>q", group = "session/quit" },
	{ "<leader>r", group = "refactor" },
	{ "<leader>t", group = "toggle" },
	{ "<leader>x", group = "diagnostics/trouble" },
	{ "<leader>m", group = "markdown" },
})
