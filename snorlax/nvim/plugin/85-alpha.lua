vim.pack.add({
	{ src = "https://github.com/goolord/alpha-nvim" },
})

if vim.fn.argc() > 0 then return end

math.randomseed(os.time())
local p = require("grove.palette")
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune")

local accents = { p.base08, p.base09, p.base0A, p.base0B, p.base0C, p.base0D, p.base0E }
local function randomize_hl(group) vim.api.nvim_set_hl(0, group, { fg = accents[math.random(#accents)] }) end

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
	dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
	dashboard.button("o", "󰋚  Recent files", "<cmd>Telescope oldfiles<CR>"),
	dashboard.button("g", "󰱼  Grep codebase", "<cmd>Telescope live_grep<CR>"),
	dashboard.button("e", "󰈔  New buffer", "<cmd>ene<CR>"),
	dashboard.button("c", "  Edit nvim config", "<cmd>e ~/.config/nvim<CR>"),
	dashboard.button("q", "󰗼  Quit", "<cmd>qa<CR>"),
}
dashboard.section.buttons.opts.hl = "AlphaButtons"

local fortune_section = { type = "text", val = fortune(), opts = { hl = "AlphaQuote", position = "center" } }

local v = vim.version()
dashboard.section.footer.val = {
	" .・。.・゜✭・.・✫・゜・。.",
	string.format(" %d plugins · nvim v%d.%d.%d", #vim.pack.get(), v.major, v.minor, v.patch),
	"    . ݁₊ ⊹ . ݁ ⟡ ݁ . ⊹ ₊ ݁.    ",
}
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

randomize_hl("AlphaHeader")
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = p.base05 })
randomize_hl("AlphaQuote")
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = p.base0D, italic = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "alpha",
	callback = function() vim.opt_local.foldenable = false end,
})
