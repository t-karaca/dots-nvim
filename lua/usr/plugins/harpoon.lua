---@module "lazy"
---@type LazyPluginSpec
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
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

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Add file to harpoon" })

        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle harpoon quick menu" })

        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end, { desc = "Navigate to harpoon file 1" })

        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end, { desc = "Navigate to harpoon file 2" })

        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end, { desc = "Navigate to harpoon file 3" })

        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end, { desc = "Navigate to harpoon file 4" })

        vim.keymap.set("n", "<leader>5", function()
            harpoon:list():select(5)
        end, { desc = "Navigate to harpoon file 5" })
    end,
}
