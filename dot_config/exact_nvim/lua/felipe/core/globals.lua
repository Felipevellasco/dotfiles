local M = {}

-- Detect if running through SSH
M.isSSH = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil

-- Detect if using VS Code with VSCode Neovim
M.isCode = vim.g.vscode

-- Check if external variable NVIM_MODE is minimal
M.isMinimal = vim.env.NVIM_MODE == 'minimal'

-- Verifies if running on Windows
M.isWin = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1

-- Detect if a clipboard tool is available
M.clipboard = false
if M.isWin then
  -- Windows
  M.clipboard = vim.fn.executable 'clip' == 1
else
  -- Linux/Unix
  M.clipboard = vim.fn.executable 'xclip' == 1 or vim.fn.executable 'xsel' == 1 or vim.fn.executable 'wl-copy' == 1 or vim.fn.executable 'pbcopy' == 1 -- macOS
end

-- Dynamically find obsidian vaults based on a set of specified candidates
M.obsidianVaults = {
  { name = 'Pessoal', path = 'D:/Obsidian/Brain' },
  { name = 'Trabalho', path = 'D:/Obsidian/Trabalho' },
  { name = 'Pessoal (fallback)', path = 'D:/Documentos/Obsidian/Brain' },
}

return M
