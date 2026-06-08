vim.pack.add({
	{ src = "https://github.com/A7Lavinraj/fyler.nvim" },
})

require("fyler").setup({
	views = {
		finder = {
			default_explorer = false,
			delete_to_trash = true,
			confirm_simple = true,
			follow_current_file = true,
			close_on_select = false,
			indentscope = { enabled = false },
			win = {
				kind = "split_left_most",
				kinds = {
					split_left_most = {
						width = "20%",
					},
				},
			},
			mappings = {
				["q"] = "CloseView",
				["<CR>"] = "Select",
				["go"] = "SelectTab",
				["gv"] = "SelectVSplit",
				["gh"] = "SelectSplit",
				["-"] = "GotoParent",
				["^"] = "GotoParent",
				["="] = "GotoCwd",
				["."] = "GotoNode",
				["#"] = "CollapseAll",
				["<BS>"] = "CollapseNode",
			},
		},
	},
	integrations = {
		icon = "nvim_web_devicons",
	},
})

vim.keymap.set("n", "<leader>E", function()
	require("fyler").toggle({ kind = "split_left_most" })
end, { desc = "fyler sidebar toggle" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fyler",
	callback = function(args)
		vim.keymap.set("n", "`", function()
			local helper = require("fyler.views.finder.helper")
			local _, dir = helper.parse_protocol_uri(vim.api.nvim_buf_get_name(args.buf))
			if dir then
				vim.cmd("cd " .. vim.fn.fnameescape(dir))
				vim.notify("cwd → " .. dir)
			end
		end, { buffer = args.buf, desc = "cd to fyler dir" })
	end,
})
