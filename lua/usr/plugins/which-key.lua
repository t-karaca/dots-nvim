---@module "lazy"
---@type LazyPluginSpec
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@module 'which-key'
    ---@type wk.Opts
    opts = {
        delay = 400,
    },
}
