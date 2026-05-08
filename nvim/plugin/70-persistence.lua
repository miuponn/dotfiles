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

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("persistence_auto_load", { clear = true }),
	nested = true,
	callback = function()
		if vim.fn.argc() == 0 then
			require("persistence").load()
		end
	end,
})
