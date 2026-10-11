vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	signcolumn = true,
	numhl = false,
	linehl = false,
	current_line_blame = false,
	preview_config = { border = "rounded" },
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "]h", function()
			gs.nav_hunk("next")
		end, "next hunk")
		map("n", "[h", function()
			gs.nav_hunk("prev")
		end, "prev hunk")
		map("n", "<leader>gs", gs.stage_hunk, "stage hunk")
		map("n", "<leader>gr", gs.reset_hunk, "reset hunk")
		map("v", "<leader>gs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "stage selection")
		map("v", "<leader>gr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "reset selection")
		map("n", "<leader>gS", gs.stage_buffer, "stage buffer")
		map("n", "<leader>gR", gs.reset_buffer, "reset buffer")
		map("n", "<leader>gp", gs.preview_hunk, "preview hunk")
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, "blame line")
		map("n", "<leader>tb", gs.toggle_current_line_blame, "toggle line blame")
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "select hunk")
	end,
})
