return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
        { "s", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
    },
}
