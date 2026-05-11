vim.keymap.set("n", "<leader>gg", function()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.92)
  local height = math.floor(vim.o.lines * 0.92)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " lazygit ",
    title_pos = "center",
  })
  vim.api.nvim_set_option_value("winhighlight", "NormalFloat:Normal,FloatBorder:FloatBorder,FloatTitle:FloatBorder", { win = win })
  vim.fn.jobstart({ "lazygit" }, {
    term = true,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
      vim.cmd("checktime")
    end,
  })
  vim.cmd("startinsert")
  vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = buf })
end, { desc = "lazygit (floating)" })
