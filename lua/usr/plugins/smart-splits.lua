---@module "lazy"
---@type LazyPluginSpec
return {
    "mrjones2014/smart-splits.nvim",
    lazy = true,
    ---@module "smart-splits"
    ---@type SmartSplitsConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        default_amount = 10,
        at_edge = "stop",
    },
    keys = {
        { "<A-h>", function() require("smart-splits").resize_left() end,       desc = "Resize left" },
        { "<A-j>", function() require("smart-splits").resize_down() end,       desc = "Resize down" },
        { "<A-k>", function() require("smart-splits").resize_up() end,         desc = "Resize up" },
        { "<A-l>", function() require("smart-splits").resize_right() end,      desc = "Resize right" },
        { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Navigate left" },
        { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Navigate down" },
        { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Navigate up" },
        { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Navigate right" },
    }
}
