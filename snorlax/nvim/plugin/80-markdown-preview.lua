vim.pack.add({
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("markdown_preview_build", { clear = true }),
	callback = function(ev)
		if ev.data.spec.name == "markdown-preview.nvim" and ev.data.kind ~= "delete" then
			vim.fn.system({ "sh", "-c", "cd " .. ev.data.path .. "/app && npx --yes yarn install" })
		end
	end,
})

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "markdown preview" })
