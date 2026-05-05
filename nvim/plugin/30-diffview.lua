vim.pack.add({
  { src = "https://github.com/sindrets/diffview.nvim" },
})

require("diffview").setup({
  enhanced_diff_hl = true,
  view = {
    default = { layout = "diff2_horizontal" },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
    },
  },
  file_panel = {
    listing_style = "tree",
    win_config = { position = "left", width = 35 },
  },
})

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "diffview open" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "diffview close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "file history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "repo history" })
