return {
    "folke/trouble.nvim",
    ---@module "trouble"
    ---@type trouble.Config
    opts = {},
    cmd = "Trouble",
    keys = {
        {
            "<leader>x",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics",
        },
        {
            "<leader>X",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics",
        },
    },
}
