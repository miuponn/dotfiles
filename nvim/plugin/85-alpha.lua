vim.pack.add({
	{ src = "https://github.com/goolord/alpha-nvim" },
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune")

local grove_palette = {
	teal = "#58b0b8",
	blue = "#5090b0",
	lavender = "#a890c0",
	green = "#78b098",
	yellow = "#e8c888",
	orange = "#e89878",
	pink = "#e878a8",
}

local function random_grove_colour(palette)
	palette = palette or grove_palette
	local keys = vim.tbl_keys(palette)
	return palette[keys[math.random(#keys)]]
end

local function randomize_hl(group, palette)
	vim.api.nvim_set_hl(0, group, { fg = random_grove_colour(palette) })
end

dashboard.section.header.val = {
	"                                                     ",
	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                     ",
}
dashboard.section.header.opts.hl = "AlphaHeader"

dashboard.section.buttons.val = {
	dashboard.button("r", "󰦛  Restore session", "<cmd>lua require('persistence').load()<CR>"),
	dashboard.button("R", "󱄍  Restore last session", "<cmd>lua require('persistence').load({ last = true })<CR>"),
	dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
	dashboard.button("o", "󰋚  Recent files", "<cmd>Telescope oldfiles<CR>"),
	dashboard.button("g", "󰱼  Grep codebase", "<cmd>Telescope live_grep<CR>"),
	dashboard.button("e", "󰈔  New buffer", "<cmd>ene<CR>"),
	dashboard.button("c", "  Edit nvim config", "<cmd>e ~/.config/nvim<CR>"),
	dashboard.button("q", "󰗼  Quit", "<cmd>qa<CR>"),
}
dashboard.section.buttons.opts.hl = "AlphaButtons"

local fortune_section = { type = "text", val = fortune(), opts = { hl = "AlphaQuote", position = "center" } }

local function make_footer()
	local plugin_count = #vim.pack.get()
	local v = vim.version()
	return {
		" .・。.・゜✭・.・✫・゜・。.",
		string.format(" %d plugins · nvim v%d.%d.%d", plugin_count, v.major, v.minor, v.patch),
		"    . ݁₊ ⊹ . ݁ ⟡ ݁ . ⊹ ₊ ݁.    ",
	}
end

dashboard.section.footer.val = make_footer()
dashboard.section.footer.opts.hl = "AlphaFooter"

dashboard.config.layout = {
	{ type = "padding", val = 2 },
	dashboard.section.header,
	{ type = "padding", val = 2 },
	dashboard.section.buttons,
	{ type = "padding", val = 1 },
	fortune_section,
	{ type = "padding", val = 2 },
	dashboard.section.footer,
}

alpha.setup(dashboard.config)

vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#58b0b8" })
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#e4ebe4" })
randomize_hl("AlphaQuote")
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#5090b0", italic = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "alpha",
	callback = function()
		vim.opt_local.foldenable = false
	end,
})
