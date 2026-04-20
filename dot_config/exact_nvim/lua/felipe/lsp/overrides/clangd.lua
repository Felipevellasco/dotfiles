return {
	cmd = { "clangd", "--compile-commands-dir=." },
	settings = {
		diagnostics = { disable = { "-mlongcalls" } },
	},
}
