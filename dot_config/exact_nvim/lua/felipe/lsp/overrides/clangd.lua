return {
	cmd = {
		"clangd",
		"--compile-commands-dir=.",
		"--background-index",
		"--query-driver=~/.platformio/packages/toolchain-xtensa32/bin/xtensa-esp32-elf-gcc*",
	},
	-- root_markers = {},
	settings = {
		-- diagnostics = { disable = { "-mlongcalls" } },
	},
}
