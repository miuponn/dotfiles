vim.pack.add({
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

local harpoon = require("harpoon")
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "harpoon add" })
vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon menu" })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "harpoon 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "harpoon 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "harpoon 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "harpoon 4" })
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "harpoon prev" })
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "harpoon next" })
