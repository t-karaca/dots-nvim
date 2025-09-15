local M = {}

---@param win number
---@param buf number
function M.windowFilter(win, buf)
    local filetype = vim.bo[buf].filetype

    local excludedFileTypes = {
        "NvimTree",
        "dap-repl",
        "dapui_console",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_scopes",
    }

    return not vim.list_contains(excludedFileTypes, filetype)
end

return M
