---@module "lazy"
---@type LazyPluginSpec
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ---@module "gitsigns"
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 0,
        },
    }
}
