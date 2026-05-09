vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
})

local telescope = require("telescope")
local actions = require("telescope.actions")
local fzf_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"

if vim.fn.isdirectory(fzf_path) == 1 and vim.fn.filereadable(fzf_path .. "/build/libfzf.so") == 0 then
	vim.fn.system({ "sh", "-c", "cd " .. fzf_path .. " && make" })
end

local ignore = {
	"node_modules/",
	"target/",
	"build/",
	"dist/",
	"__pycache__/",
	"%.venv/",
	"%.git/",
	"%.cache/",
	"%.next/",
	"%.png$",
	"%.jpe?g$",
	"%.gif$",
	"%.webp$",
	"%.ico$",
	"%.svg$",
	"%.pdf$",
	"%.zip$",
	"%.tar%.gz$",
	"%.gz$",
	"%.tgz$",
	"%.7z$",
	"%.rar$",
	"%.mp4$",
	"%.mov$",
	"%.avi$",
	"%.webm$",
	"%.mp3$",
	"%.wav$",
	"%.flac$",
	"%.ttf$",
	"%.otf$",
	"%.woff2?$",
	"%.lock$",
	"%.min%.js$",
	"%.min%.css$",
	"%.DS_Store$",
	"%.o$",
	"%.a$",
	"%.so$",
	"%.dylib$",
	"%.exe$",
}

telescope.setup({
	defaults = {
		prompt_title = false,
		results_title = false,
		preview_title = false,
		prompt_prefix = "  ",
		selection_caret = " ",
		winblend = 0,
		path_display = { "smart" },
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = { prompt_position = "top", preview_width = 0.55 },
			width = 0.87,
			height = 0.80,
		},
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<esc>"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			file_ignore_patterns = ignore,
		},
		live_grep = { file_ignore_patterns = ignore },
		buffers = {
			sort_lastused = true,
			sort_mru = true,
			ignore_current_buffer = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("telescope_fzf_build", { clear = true }),
	callback = function(ev)
		if ev.data.spec.name == "telescope-fzf-native.nvim" and ev.data.kind ~= "delete" then
			vim.fn.system({ "sh", "-c", "cd " .. ev.data.path .. " && make" })
		end
	end,
})

pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "grep codebase" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "find buffer" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "find help" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "recent files" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "find keymaps" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "find commands" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "document symbols" })
vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "workspace symbols" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "find in buffer" })
