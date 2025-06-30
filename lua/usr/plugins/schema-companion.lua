return {
    "cenk1cenk2/schema-companion.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
    },
    config = function()
        require("schema-companion").setup({
            enable_telescope = false,
            matchers = {
                -- add your matchers
                require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
            },
        })

        -- vim.keymap.set("n", "<leader>fy", function()
        --     require("telescope").extensions.schema_companion.select_schema()
        -- end)
    end,
}
