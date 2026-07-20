local function get_clangd_binary()
	-- Captura o PATH atual do ambiente do sistema
	local path_env = vim.env.PATH or ""

	-- Divide o PATH usando ":" como separador (padrão do Linux)
	for dir in string.gmatch(path_env, "[^:]+") do
		-- Se o diretório NÃO for o do Mason, verifica se há um clangd executável nele
		if not string.find(dir, "mason") then
			local potential_binary = dir .. "/clangd"
			if vim.fn.executable(potential_binary) == 1 then
				-- vim.notify("Clangd do projeto interceptado com sucesso: " .. potential_binary, vim.log.levels.INFO)
				return potential_binary
			end
		end
	end

	-- Se não achou nenhum fora o do Mason, deixa o exepath/sistema lidar como fallback
	return "clangd"
end

return {
	cmd = {
		get_clangd_binary(),
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--background-index",
		"--query-driver=~/.platformio/packages/toolchain-xtensa*/**/bin/*gcc*",
	},
	settings = {
		-- diagnostics = { disable = { "-mlongcalls" } },
	},
}
