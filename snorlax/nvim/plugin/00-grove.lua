vim.pack.add({
	{ src = "https://github.com/RRethy/base16-nvim" },
})

local p = require("grove.palette")

require("base16-colorscheme").setup(p, { telescope = false })
vim.g.colors_name = "grove"

local function apply_transparency()
	local groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"FoldColumn",
		"MsgArea",
		"StatusLine",
		"StatusLineNC",
		"TabLineFill",
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "NONE" })
	end
end

local function apply_grove_overrides()
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.teal_bright, bg = "NONE" })
	vim.api.nvim_set_hl(0, "LineNr", { fg = p.teal_dim, bg = "NONE" })

	vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = p.base03, bg = "NONE" })
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = p.teal_dim, bg = "NONE" })
	-- tab labels
	vim.api.nvim_set_hl(0, "TabLineSel", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TabLine", { fg = p.base03, bg = "NONE" })
	-- telescope borders
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = p.base0C, bg = "NONE" })
	-- telescope title blocks
	vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = p.base03, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = p.base03, bg = "NONE" })
	-- telescope inner panes
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
	-- telescope selection/matching hlights
	vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = p.base05, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = p.base0A })
	vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = p.base09 })
	vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = p.base0E })
	vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = p.base03, bg = "NONE" })
	-- which key
	vim.api.nvim_set_hl(0, "WhichKey", { fg = p.base0B })
	vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = p.base0D, bold = true })

	vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = p.base05 })
	vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = p.base03 })
	vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = p.base0C, bg = "NONE" })

	vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = p.base03 })

	-- pmenu
	vim.api.nvim_set_hl(0, "Pmenu", { fg = p.base04, bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = p.base05, bg = p.base02, bold = true })
	vim.api.nvim_set_hl(0, "PmenuBorder", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuMatch", { fg = p.base09, bold = true })
	vim.api.nvim_set_hl(0, "PmenuMatchSel", { fg = p.base09, bg = p.base02, bold = true })
	vim.api.nvim_set_hl(0, "PmenuKind", { fg = p.teal_bright, bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuKindSel", { fg = p.base0A, bg = p.base02 })
	vim.api.nvim_set_hl(0, "PmenuExtra", { fg = p.base03, bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuExtraSel", { fg = p.base03, bg = p.base02 })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = p.base02 })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = p.teal_dim })

	-- diagnostics
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = p.base08 })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = p.base0A })
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = p.base0C })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = p.base0E })
	vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = p.base0B })

	-- virtual text inline
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = p.base08, bg = "NONE", italic = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = p.base0A, bg = "NONE", italic = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = p.base0C, bg = "NONE", italic = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = p.base0E, bg = "NONE", italic = true })
	-- sign column markers
	vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = p.base08, bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = p.base0A, bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = p.base0E, bg = "NONE" })
	-- underline (squiggly under offending tokens)
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = p.base08, undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = p.base0A, undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = p.base0C, undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = p.base0E, undercurl = true })
	-- floating window text (when you :open_float)
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = p.base08, bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = p.base0A, bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = p.base0C, bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = p.base0E, bg = "NONE" })

	-- git signs
	vim.api.nvim_set_hl(0, "GitGutterAdd", { fg = p.base0B, bg = "NONE" })
	vim.api.nvim_set_hl(0, "GitGutterChange", { fg = p.base0A, bg = "NONE" })
	vim.api.nvim_set_hl(0, "GitGutterDelete", { fg = p.base08, bg = "NONE" })
	vim.api.nvim_set_hl(0, "GitGutterChangeDelete", { fg = p.base0E, bg = "NONE" })

	-- fyler
	vim.api.nvim_set_hl(0, "FylerFSFile", { fg = p.base05 })
	vim.api.nvim_set_hl(0, "FylerGitModified", { fg = p.base0A })
	vim.api.nvim_set_hl(0, "FylerGitRenamed", { fg = p.base0A })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "grove",
	group = vim.api.nvim_create_augroup("grove_highlights", { clear = true }),
	callback = function()
		apply_transparency()
		apply_grove_overrides()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "TelescopePrompt", "TelescopeResults" },
	callback = function()
		local hl = vim.bo.filetype == "TelescopePrompt" and "TelescopePromptNormal" or "TelescopeResultsNormal"
		vim.wo.winhighlight = ("Normal:%s,EndOfBuffer:%s,NonText:%s"):format(hl, hl, hl)
	end,
})

apply_transparency()
apply_grove_overrides()
