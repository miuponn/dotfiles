vim.pack.add({
	{ src = "https://github.com/RRethy/base16-nvim" },
})

require("base16-colorscheme").setup({
	base00 = "#13242a",
	base01 = "#1b2f34",
	base02 = "#263d42",
	base03 = "#5a7880",
	base04 = "#8098a0",
	base05 = "#e4ebe4",
	base06 = "#eef4ec",
	base07 = "#f6faf4",
	base08 = "#e878a8",
	base09 = "#e89878",
	base0A = "#e8c888",
	base0B = "#78b098",
	base0C = "#58b0b8",
	base0D = "#5090b0",
	base0E = "#a890c0",
	base0F = "#78786a",
}, {
	telescope = false,
})

vim.g.colors_name = "grove"

local function apply_transparency()
	local groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"FoldColumn",
		"LineNr",
		"CursorLineNr",
		"EndOfBuffer",
		"MsgArea",
		"StatusLine",
		"StatusLineNC",
		"VertSplit",
		"WinSeparator",
		"TabLine",
		"TabLineFill",
		"TabLineSel",
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "NONE" })
	end
end

local function apply_grove_overrides()
	-- telescope borders
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#58b0b8", bg = "NONE" })
	-- telescope title blocks
	vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#5a7880", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#5a7880", bg = "NONE" })
	-- telescope inner panes
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
	-- telescope selection/matching hlights
	vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#e4ebe4", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#e8c888" })
	vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#e89878" })
	vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = "#a890c0" })
	vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = "#5a7880", bg = "NONE" })
	-- which key
	vim.api.nvim_set_hl(0, "WhichKey", { fg = "#78b098" })
	vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = "#5090b0", bold = true })

	vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = "#e4ebe4" })
	vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = "#5a7880" })
	vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = "#58b0b8", bg = "NONE" })

	vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = "#5a7880" })

	-- pmenu
	vim.api.nvim_set_hl(0, "Pmenu", { fg = "#8098a0", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#e4ebe4", bg = "#263d42", bold = true })
	vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuMatch", { fg = "#e89878", bold = true })
	vim.api.nvim_set_hl(0, "PmenuMatchSel", { fg = "#e89878", bg = "#263d42", bold = true })
	vim.api.nvim_set_hl(0, "PmenuKind", { fg = "#6ec5cd", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuKindSel", { fg = "#e8c888", bg = "#263d42" })
	vim.api.nvim_set_hl(0, "PmenuExtra", { fg = "#5a7880", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PmenuExtraSel", { fg = "#5a7880", bg = "#263d42" })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#263d42" })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#4a8c92" })

	-- diagnostics
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#e878a8" })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e8c888" })
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#58b0b8" })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#a890c0" })
	vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#78b098" })

	-- virtual text inline
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#e878a8", bg = "NONE", italic = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e8c888", bg = "NONE", italic = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#58b0b8", bg = "NONE", italic = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a890c0", bg = "NONE", italic = true })
	-- sign column markers
	vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#e878a8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#e8c888", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#a890c0", bg = "NONE" })
	-- underline (squiggly under offending tokens)
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#e878a8", undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#e8c888", undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = "#58b0b8", undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#a890c0", undercurl = true })
	-- floating window text (when you :open_float)
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = "#e878a8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = "#e8c888", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = "#58b0b8", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = "#a890c0", bg = "NONE" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("grove_transparency", { clear = true }),
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
