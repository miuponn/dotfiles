vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

local grove = {
	pink = "#e878a8",
	orange = "#e89878",
	yellow = "#e8c888",
	green = "#78b098",
	teal = "#58b0b8",
	blue = "#5090b0",
	lavender = "#a890c0",
	olive = "#78786a",
	periwinkle = "#7887ba",
	dark = "#1b2f34",
	elevated = "#263d42",
	muted = "#5a7880",
	fg = "#e4ebe4",
}

local pills = {
	normal = {
		a = { fg = grove.dark, bg = grove.blue },
		b = { fg = grove.fg, bg = grove.dark },
		c = { fg = grove.muted },
	},
	insert = { a = { fg = grove.dark, bg = grove.green } },
	visual = { a = { fg = grove.dark, bg = grove.lavender } },
	replace = { a = { fg = grove.dark, bg = grove.orange } },
	command = { a = { fg = grove.dark, bg = grove.yellow } },
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
		section_separators = { left = "", right = "" },
		globalstatus = true,
		disabled_filetypes = {
			statusline = { "trouble", "oil", "dashboard" },
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				separator = { left = "" },
				padding = { left = 0, right = 1 },
			},
		},
		lualine_b = {
			"branch",
			"diff",
			{ "diagnostics", sources = { "nvim_diagnostic" }, separator = { right = "" } },
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
			{ "progress", separator = { left = "" } },
		},
		lualine_z = {
			{ "location", separator = { right = "" }, padding = { left = 0, right = 0 } },
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
