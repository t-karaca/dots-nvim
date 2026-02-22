---@module "lazy"
---@type LazyPluginSpec
return {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {},
    keys = {
        { "s", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
    },
}
