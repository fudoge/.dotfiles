local M = {}

-- Mac: macOS
M.is_mac = function()
    return vim.fn.has("macunix") == 1
end

-- Windows native Neovim (not WSL)
M.is_windows = function()
    return vim.fn.has("win32") == 1
end

-- WSL (Windows Subsystem for Linux)
M.is_wsl = function()
    -- "wsl" 있는 경우 + "linux"는 1
    return vim.fn.has("wsl") == 1
end

-- Linux (excluding mac and WSL)
M.is_linux = function()
    return vim.fn.has("unix") == 1 and not M.is_mac() and not M.is_wsl()
end

return M
