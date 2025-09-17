---@module "lazy"
---@type LazyPluginSpec
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        local extensions = require("harpoon.extensions")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
            },
        })

        harpoon:extend(extensions.builtins.highlight_current_file())
        harpoon:extend(extensions.builtins.navigate_with_number())
    end,
    keys = {
        { "<leader>a", function() require("harpoon"):list():add() end,     desc = "Add file to harpoon" },
        { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Navigate to harpoon file 1" },
        { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Navigate to harpoon file 2" },
        { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Navigate to harpoon file 3" },
        { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Navigate to harpoon file 4" },
        { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Navigate to harpoon file 5" },
        {
            "<C-e>",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Add file to harpoon"
        },
    }
}
