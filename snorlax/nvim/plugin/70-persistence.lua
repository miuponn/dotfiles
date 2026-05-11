vim.pack.add({
	{ src = "https://github.com/folke/persistence.nvim" },
})

require("persistence").setup()

vim.keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "restore session" })
vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "restore last session" })
vim.keymap.set("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "don't save session" })
