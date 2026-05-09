vim.pack.add({
	{ src = "https://github.com/goolord/alpha-nvim" },
})

local dashboard = require("alpha.themes.dashboard")

require("alpha").setup(dashboard.config)
