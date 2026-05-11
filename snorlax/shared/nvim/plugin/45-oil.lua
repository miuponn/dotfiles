vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name)
      return name == ".." or name == ".git" or name == ".DS_Store"
    end,
  },
  float = {
    border = "rounded",
    max_width = 100,
    max_height = 30,
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["gv"] = { "actions.select", opts = { vertical = true } },
    ["gh"] = { "actions.select", opts = { horizontal = true } },
    ["go"] = { "actions.select", opts = { tab = true } },
    ["gp"] = "actions.preview",
    ["gc"] = "actions.close",
    ["gR"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
  },
  use_default_keymaps = false,
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "open parent dir (oil)" })
vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "open oil float" })
