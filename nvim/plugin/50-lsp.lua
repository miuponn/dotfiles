vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls", "eslint", "tailwindcss", "cssls",
    "html", "jsonls", "emmet_language_server", "lua_ls",
    "basedpyright", "ruff",
  },
  automatic_enable = true,
})

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client then return end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/codeLens") then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
        buffer = bufnr,
        group = vim.api.nvim_create_augroup("lsp_codelens_" .. bufnr, { clear = true }),
        callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      })
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "K", vim.lsp.buf.hover, "hover docs")
    map("n", "gd", vim.lsp.buf.definition, "goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "goto declaration")
    map("n", "gi", vim.lsp.buf.implementation, "goto implementation")
    map("n", "gt", vim.lsp.buf.type_definition, "goto type definition")
    map("n", "gr", vim.lsp.buf.references, "references")
    map("n", "<leader>rn", vim.lsp.buf.rename, "rename")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "code action")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, "signature help")
    map("i", "<C-s>", vim.lsp.buf.signature_help, "signature help")
    map("n", "<leader>lr", "<cmd>LspRestart<CR>", "restart lsp")
    map("n", "<leader>li", "<cmd>LspInfo<CR>", "lsp info")
    map("n", "<leader>cl", vim.lsp.codelens.run, "run codelens")
  end,
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

vim.lsp.enable({
  "ts_ls", "eslint", "tailwindcss", "cssls",
  "html", "jsonls", "emmet_language_server", "lua_ls",
  "basedpyright", "ruff",
  "rust_analyzer",
})
