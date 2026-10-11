vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"query",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"scss",
	"json",
	"yaml",
	"toml",
	"markdown",
	"markdown_inline",
	"bash",
	"python",
	"go",
	"rust",
	"regex",
	"dockerfile",
	"gitignore",
	"gitcommit",
	"requirements",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if lang and pcall(vim.treesitter.language.add, lang) then
			pcall(vim.treesitter.start, args.buf, lang)
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = { ["@parameter.outer"] = "v", ["@function.outer"] = "V", ["@class.outer"] = "<c-v>" },
		include_surrounding_whitespace = false,
	},
})

local ts_select = require("nvim-treesitter-textobjects.select")
for key, query in pairs({
	["af"] = "@function.outer",
	["if"] = "@function.inner",
	["ac"] = "@class.outer",
	["ic"] = "@class.inner",
	["aa"] = "@parameter.outer",
	["ia"] = "@parameter.inner",
}) do
	vim.keymap.set({ "x", "o" }, key, function()
		ts_select.select_textobject(query, "textobjects")
	end, { desc = "textobject " .. query })
end

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("treesitter_update", { clear = true }),
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
			pcall(function()
				require("nvim-treesitter").update()
			end)
		end
	end,
})
