vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
})

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = "  ",
    selection_caret = " ",
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55 },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = { hidden = true, file_ignore_patterns = { ".git/", "node_modules/" } },
    live_grep = { file_ignore_patterns = { ".git/", "node_modules/" } },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("telescope_fzf_build", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == "telescope-fzf-native.nvim" and ev.data.kind ~= "delete" then
      vim.fn.system({ "sh", "-c", "cd " .. ev.data.path .. " && make" })
    end
  end,
})

pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "grep codebase" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "find buffer" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "find help" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "recent files" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "find keymaps" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "find commands" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "document symbols" })
vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "workspace symbols" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "find in buffer" })
