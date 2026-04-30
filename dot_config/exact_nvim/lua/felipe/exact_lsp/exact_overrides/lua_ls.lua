return {
	-- cmd = { ... },
	-- filetypes = { ... },
	-- capabilities = {},
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- disable = { 'missing-fields' },
			},
		},
	},
}
