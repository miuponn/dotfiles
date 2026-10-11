vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

local p = require("grove.palette")
local grove = {
	pink = p.base08, orange = p.base09, yellow = p.base0A, mint = p.base0B,
	lime = p.lime, lime_bright = p.lime_bright,
	teal = p.base0C, blue = p.base0D, lavender = p.base0E, olive = p.base0F, periwinkle = p.periwinkle,
	dark = p.base01, elevated = p.base02, muted = p.base03, dim = p.base04, fg = p.base05,
}

local pills = {
	normal = {
		a = { fg = grove.dark, bg = grove.teal, bold = true },
		b = { fg = grove.fg, bg = grove.dark },
		c = { fg = grove.muted },
	},
	insert = { a = { fg = grove.dark, bg = grove.mint, bold = true } },
	visual = { a = { fg = grove.dark, bg = grove.lavender, bold = true } },
	replace = { a = { fg = grove.dark, bg = grove.orange, bold = true } },
	command = { a = { fg = grove.dark, bg = grove.yellow, bold = true } },
	inactive = {
		a = { fg = grove.muted, bg = grove.elevated },
		b = { fg = grove.muted, bg = grove.elevated },
		c = { fg = grove.muted },
	},
}

local function lsp_names()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end
	local names = {}
	for _, c in ipairs(clients) do
		table.insert(names, c.name)
	end
	return table.concat(names, ", ")
end

require("lualine").setup({
	options = {
		theme = pills,
		icons_enabled = true,
		component_separators = "",
		section_separators = { left = "", right = "" },
		globalstatus = true,
		disabled_filetypes = {
			statusline = { "trouble", "oil", "dashboard" },
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				separator = { left = "", right = "" },
				padding = { left = 1, right = 1 },
			},
		},
		lualine_b = {
			"branch",
			"diff",
			{ "diagnostics", sources = { "nvim_diagnostic" }, separator = { right = "" } },
		},
		lualine_c = {
			{ "filename", path = 1 },
		},
		lualine_x = {
			{
				lsp_names,
				cond = function()
					return #vim.lsp.get_clients({ bufnr = 0 }) > 0
				end,
				icon = "",
				color = { fg = grove.lavender },
			},
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = {
			{ "progress", separator = { left = "" } },
		},
		lualine_z = {
			{ "location", separator = { left = "", right = "" }, padding = { left = 0, right = 1 } },
			{
				function()
					return " "
				end,
				color = { bg = "NONE" },
				padding = 0,
			},
		},
	},
	extensions = { "quickfix", "trouble", "oil" },
})
