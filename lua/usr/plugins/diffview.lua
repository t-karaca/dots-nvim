---@module "lazy"
---@type LazyPluginSpec
return {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
    },
    keys = {
        {
            "<leader>dv",
            "<cmd>DiffviewOpen<CR>",
            desc = "Open diffview",
        },
        {
            "<leader>df",
            "<cmd>DiffviewFileHistory %<CR>",
            desc = "History for current file",
        },
        {
            "<leader>dc",
            "<cmd>DiffviewClose<CR>",
            desc = "Close diffview",
        },
    },
    ---@module "diffview"
    ---@type DiffviewConfig
    opts = {},
}
