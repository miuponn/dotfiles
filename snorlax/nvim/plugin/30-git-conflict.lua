vim.pack.add({
	{ src = "https://github.com/akinsho/git-conflict.nvim" },
})

require("git-conflict").setup({
	default_mappings = true,
	default_commands = true,
	disable_diagnostics = false,
	list_opener = "copen",
	highlights = { incoming = "DiffAdd", current = "DiffText" },
})

vim.keymap.set("n", "<leader>gx", "<cmd>GitConflictListQf<CR>", { desc = "list conflicts" })
