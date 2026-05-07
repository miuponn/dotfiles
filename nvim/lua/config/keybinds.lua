vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clear search highlights" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "move to right split" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "increase window width" })

vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "delete buffer" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "half-page down centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "half-page up centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "next search match centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search match centered" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "indent left, stay selected" })
vim.keymap.set("v", ">", ">gv", { desc = "indent right, stay selected" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste without yank" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete without yanking" })

vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "prev diagnostic" })
vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "diagnostic float" })
vim.keymap.set("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "diagnostics to loclist" })

vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "write buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { desc = "quit window" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "force quit all" })

vim.keymap.set("n", "<leader>cr", function()
  vim.cmd("checktime")
  pcall(vim.cmd, "DiffviewOpen")
end, { desc = "claude return (reload + diffview)" })

vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "toggle inlay hints" })

vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "next completion or insert tab" })

vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "prev completion or shift-tab" })
