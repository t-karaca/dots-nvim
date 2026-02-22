---@module "lazy"
---@type LazyPluginSpec
return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ---@module "todo-comments"
    ---@type TodoOptions
    opts = {},
}
