vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs" },
})

require("nvim-autopairs").setup({
  map_cr = false,
  check_ts = true,
  ts_config = {
    lua = { "string" },
    javascript = { "template_string" },
    typescript = { "template_string" },
  },
  disable_filetype = { "TelescopePrompt", "vim" },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,]]=],
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    manual_position = true,
    highlight = "Search",
    highlight_grey = "Comment",
  },
})
