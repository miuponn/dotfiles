vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		if not client then
			return
		end

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
		end

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		if client:supports_method("textDocument/codeLens") then
			vim.lsp.codelens.enable(true, { bufnr = bufnr })
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
		map("n", "<leader>lr", "<cmd>lsp restart<CR>", "restart lsp")
		map("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", "lsp info")
		map("n", "<leader>cl", vim.lsp.codelens.run, "run codelens")

		if client.name == "texlab" then
			map("n", "<leader>lb", "<cmd>LspTexlabBuild<CR>", "latex build")
			map("n", "<leader>lv", "<cmd>LspTexlabForward<CR>", "latex forward search")
		end
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
	"ts_ls",
	"eslint",
	"tailwindcss",
	"cssls",
	"html",
	"jsonls",
	"emmet_language_server",
	"lua_ls",
	"basedpyright",
	"ruff",
	"rust_analyzer",
	"gopls",
	"texlab",
})
