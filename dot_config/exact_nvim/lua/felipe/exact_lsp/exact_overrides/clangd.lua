return {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--background-index",
		"--query-driver=~/.platformio/packages/toolchain-xtensa32/bin/xtensa-esp32-elf-gcc*",
	},
	settings = {
		-- diagnostics = { disable = { "-mlongcalls" } },
	},
}
