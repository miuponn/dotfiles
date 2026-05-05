vim.pack.add({
  { src = "https://github.com/RRethy/base16-nvim" },
})

require("base16-colorscheme").setup({
  base00 = "#13242a", base01 = "#1b2f34", base02 = "#263d42", base03 = "#5a7880",
  base04 = "#8098a0", base05 = "#e4ebe4", base06 = "#eef4ec", base07 = "#f6faf4",
  base08 = "#e878a8", base09 = "#e89878", base0A = "#e8c888", base0B = "#78b098",
  base0C = "#58b0b8", base0D = "#5090b0", base0E = "#a890c0", base0F = "#78786a",
})

vim.g.colors_name = "grove"

local function apply_transparency()
  local groups = {
    "Normal", "NormalNC", "NormalFloat", "FloatBorder",
    "SignColumn", "FoldColumn", "LineNr", "CursorLineNr",
    "EndOfBuffer", "MsgArea", "StatusLine", "StatusLineNC",
    "VertSplit", "WinSeparator", "TabLine", "TabLineFill", "TabLineSel",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("grove_transparency", { clear = true }),
  callback = apply_transparency,
})

apply_transparency()
