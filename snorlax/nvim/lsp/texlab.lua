return {
	settings = {
		texlab = {
			build = {
				forwardSearchAfter = true,
			},
			forwardSearch = {
				executable = "displayline",
				args = { "-r", "-b", "%l", "%p", "%f" },
			},
			chktex = {
				onOpenAndSave = true,
				onEdit = false,
			},
		},
	},
}
