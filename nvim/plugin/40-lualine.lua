vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require("lualine").setup({
  options = {
    theme = "base16",
    icons_enabled = true,
    component_separators = "",
    section_separators = "",
    globalstatus = true,
    disabled_filetypes = {
      statusline = { "trouble", "oil", "alpha", "dashboard" },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "quickfix", "trouble", "oil" },
})
